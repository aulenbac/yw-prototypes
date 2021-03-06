package org.yesworkflow.model;

import java.io.IOException;
import java.io.PrintStream;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import org.yesworkflow.annotations.Annotation;
import org.yesworkflow.annotations.Begin;
import org.yesworkflow.annotations.End;
import org.yesworkflow.annotations.In;
import org.yesworkflow.annotations.Out;
import org.yesworkflow.annotations.Return;
import org.yesworkflow.config.YWConfiguration;
import org.yesworkflow.exceptions.YWMarkupException;
import org.yesworkflow.query.LogicLanguage;

public class DefaultModeler implements Modeler {

    static private LogicLanguage DEFAULT_LOGIC_LANGUAGE = LogicLanguage.PROLOG;

    private List<Annotation> annotations;
    private Model model;
    private String topWorkflowName = null;
    private PrintStream stdoutStream = null;
    private PrintStream stderrStream = null;
    private String factsFile = null;
    private String modelFacts = null;
    private LogicLanguage logicLanguage = DEFAULT_LOGIC_LANGUAGE;
    
    public DefaultModeler() {
        this(System.out, System.err);
    }

    public DefaultModeler(PrintStream stdoutStream, PrintStream stderrStream) {
        this.stdoutStream = stdoutStream;
        this.stderrStream = stderrStream;
    }
    
    @Override
    public DefaultModeler configure(Map<String,Object> config) throws Exception {
        if (config != null) {
            for (Map.Entry<String, Object> entry : config.entrySet()) {
                configure(entry.getKey(), entry.getValue());
            }
        }
        return this;
    }

    @Override
    public DefaultModeler configure(String key, Object value) throws Exception {
        if (key.equalsIgnoreCase("workflow")) {
            topWorkflowName = (String)value;
        } else if (key.equalsIgnoreCase("factsfile")) {
           factsFile = (String)value;
        } else if (key.equalsIgnoreCase("logic")) {
            logicLanguage = LogicLanguage.toLogicLanguage((String)value);
        }
        return this;
    }  
    
    @Override
    public Modeler annotations(List<Annotation> annotations) {
        this.annotations = annotations;
        return this;
    }

    @Override
    public Modeler model() throws Exception {	
    	buildModel();
    	if (factsFile != null) {
    	    writeTextToFileOrStdout(factsFile, getFacts());
    	}
    	return this;
    }
    
    @Override
    public Model getModel() {
        return this.model;
    }

    @Override
    public String getFacts() {
        if (modelFacts == null) {
            modelFacts = new ModelFacts(logicLanguage, model).build().toString();
        }
        return modelFacts;
    }

    private void writeTextToFileOrStdout(String path, String text) throws IOException {  
        PrintStream stream = (path.equals(YWConfiguration.EMPTY_VALUE) || path.equals("-")) ?
                             this.stdoutStream : new PrintStream(path);
        stream.print(text);
        if (stream != this.stdoutStream) {
            stream.close();
        }
    }

    private void buildModel() throws Exception {

        WorkflowBuilder workflowBuilder = null;
        WorkflowBuilder topWorkflowBuilder = null;
        Program topProgram = null;
        WorkflowBuilder parentBuilder = null;
        Stack<WorkflowBuilder> parentWorkflowBuilders = new Stack<WorkflowBuilder>();
        List<Function> functions = new LinkedList<Function>();
        
        Integer nextProgramId = 1;
        Integer nextPortId = 1;

        for (Annotation annotation : annotations) {

            if (annotation instanceof Begin) {

                if (workflowBuilder != null) {
                    parentWorkflowBuilders.push(workflowBuilder);
                    parentBuilder = workflowBuilder;
                }

                workflowBuilder = new WorkflowBuilder(nextProgramId++, this.stdoutStream, this.stderrStream)
                    .begin((Begin)annotation);
                
                if (topWorkflowBuilder == null) { 
                    String blockName = ((Begin)annotation).name;
                    if (topWorkflowName == null || topWorkflowName.equals(blockName)) {
                        topWorkflowBuilder = workflowBuilder;
                    }
                }

            } else if (annotation instanceof Return) {
                
                Port returnPort = new Port(nextPortId++, (Return)annotation, workflowBuilder.getBeginAnnotation());
                workflowBuilder.returnPort(returnPort);

            } else if (annotation instanceof Out) {
                Port outPort = new Port(nextPortId++, (Out)annotation, workflowBuilder.getBeginAnnotation());
                workflowBuilder.outPort(outPort);
                if (parentBuilder != null) {
                    parentBuilder.nestedOutPort(outPort);
                }

            } else if (annotation instanceof In) {
                Port port = new Port(nextPortId++, (In)annotation, workflowBuilder.getBeginAnnotation());                
                workflowBuilder.inPort(port);
                if (parentBuilder != null) {
                    parentBuilder.nestedInPort(port);
                }

            } else if (annotation instanceof End) {

                workflowBuilder.end((End)annotation);                
                
                if (parentWorkflowBuilders.isEmpty()) {
                    
                    if (workflowBuilder == topWorkflowBuilder) {
                        topProgram = workflowBuilder.build();
                    } else {
                        functions.add(workflowBuilder.buildFunction());
                    }

                    workflowBuilder = null;
                    
                } else {

                    Program program = workflowBuilder.build();

                    if (program instanceof Function) {
                        parentBuilder.nestedFunction((Function)program);
                    } else {
                        parentBuilder.nestedProgram(program);
                    }
                    
                    workflowBuilder = parentWorkflowBuilders.pop();
                }
                
                if (!parentWorkflowBuilders.isEmpty()) {
                    parentBuilder = parentWorkflowBuilders.peek();
                }
            }
        }
        
        if (workflowBuilder != null) {
            // throw exception if missing any paired end comments
            StringBuilder messageBuilder = new StringBuilder();
            do {
                messageBuilder.append("ERROR: No @end comment paired with '@begin ");
                messageBuilder.append(workflowBuilder.getProgramName());
                messageBuilder.append("'");
                messageBuilder.append(EOL);
                workflowBuilder = parentWorkflowBuilders.isEmpty() ? null : parentWorkflowBuilders.pop();
            } while (workflowBuilder != null);        
            throw new YWMarkupException(messageBuilder.toString());
        }
        
        if (topProgram == null) {
            if (topWorkflowName != null) throw new YWMarkupException("No workflow named '" + topWorkflowName + "' found in source.");
            if (functions.size() == 0) throw new Exception("No program or functions found in script.");
        }
        
        model = new Model(topProgram, functions);
    }
}
