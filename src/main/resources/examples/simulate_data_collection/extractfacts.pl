
% FACT: extract_source(source_id, source_path).
extract_source(1, 'simulate_data_collection.py').

% FACT: annotation(annotation_id, source_id, line_number, annotation_tag, annotation_value).
annotation(1, 1, 9, '@begin', 'simulate_data_collection').
annotation(2, 1, 10, '@param', 'cassette_id').
annotation(3, 1, 11, '@param', 'sample_score_cutoff').
annotation(4, 1, 12, '@in', 'sample_spreadsheet').
annotation(5, 1, 12, '@uri', 'file:cassette_{cassette_id}_spreadsheet.csv').
annotation(6, 1, 13, '@in', 'calibration_image').
annotation(7, 1, 13, '@uri', 'file:calibration.img').
annotation(8, 1, 14, '@out', 'corrected_image').
annotation(9, 1, 14, '@uri', 'file:run/data/{}/{}_{}eV_{}.img').
annotation(10, 1, 15, '@out', 'run_log').
annotation(11, 1, 15, '@uri', 'file:run/run_log.txt').
annotation(12, 1, 16, '@out', 'collection_log').
annotation(13, 1, 16, '@uri', 'file:run/collected_images.csv').
annotation(14, 1, 17, '@out', 'rejection_log').
annotation(15, 1, 17, '@uri', 'file:run/rejected_samples.txt').
annotation(16, 1, 23, '@begin', 'initialize_run').
annotation(17, 1, 24, '@out', 'run_log').
annotation(18, 1, 24, '@uri', 'file:run/run_log.txt').
annotation(19, 1, 33, '@end', 'initialize_run').
annotation(20, 1, 37, '@begin', 'load_screening_results').
annotation(21, 1, 38, '@param', 'cassette_id').
annotation(22, 1, 39, '@in', 'sample_spreadsheet').
annotation(23, 1, 39, '@uri', 'file:cassette_{cassette_id}_spreadsheet.csv').
annotation(24, 1, 40, '@out', 'sample_name').
annotation(25, 1, 41, '@out', 'sample_quality').
annotation(26, 1, 47, '@end', 'load_screening_results').
annotation(27, 1, 51, '@begin', 'calculate_strategy').
annotation(28, 1, 52, '@param', 'sample_score_cutoff').
annotation(29, 1, 53, '@in', 'sample_name').
annotation(30, 1, 54, '@in', 'sample_quality').
annotation(31, 1, 55, '@out', 'accepted_sample').
annotation(32, 1, 56, '@out', 'rejected_sample').
annotation(33, 1, 57, '@out', 'num_images').
annotation(34, 1, 58, '@out', 'energies').
annotation(35, 1, 69, '@end', 'calculate_strategy').
annotation(36, 1, 73, '@begin', 'log_rejected_sample').
annotation(37, 1, 74, '@param', 'cassette_id').
annotation(38, 1, 75, '@in', 'rejected_sample').
annotation(39, 1, 76, '@out', 'rejection_log').
annotation(40, 1, 76, '@uri', 'file:/run/rejected_samples.txt').
annotation(41, 1, 85, '@end', 'log_rejected_sample').
annotation(42, 1, 89, '@begin', 'collect_data_set').
annotation(43, 1, 90, '@call', 'collect_next_image').
annotation(44, 1, 91, '@param', 'cassette_id').
annotation(45, 1, 92, '@in', 'accepted_sample').
annotation(46, 1, 93, '@in', 'num_images').
annotation(47, 1, 94, '@in', 'energies').
annotation(48, 1, 95, '@out', 'sample_id').
annotation(49, 1, 96, '@out', 'energy').
annotation(50, 1, 97, '@out', 'frame_number').
annotation(51, 1, 98, '@out', 'raw_image_path').
annotation(52, 1, 98, '@as', 'raw_image').
annotation(53, 1, 99, '@uri', 'file:run/raw/{cassette_id}/{sample_id}/e{energy}/image_{frame_number}.raw').
annotation(54, 1, 108, '@end', 'collect_data_set').
annotation(55, 1, 112, '@begin', 'transform_images').
annotation(56, 1, 113, '@call', 'transform_image').
annotation(57, 1, 114, '@in', 'sample_id').
annotation(58, 1, 115, '@in', 'energy').
annotation(59, 1, 116, '@in', 'frame_number').
annotation(60, 1, 117, '@in', 'raw_image_path').
annotation(61, 1, 117, '@as', 'raw_image').
annotation(62, 1, 118, '@in', 'calibration_image').
annotation(63, 1, 118, '@uri', 'file:calibration.img').
annotation(64, 1, 119, '@out', 'corrected_image').
annotation(65, 1, 119, '@uri', 'file:data/{sample_id}/{sample_id}_{energy}eV_{frame_number}.img').
annotation(66, 1, 120, '@out', 'corrected_image_path').
annotation(67, 1, 121, '@out', 'total_intensity').
annotation(68, 1, 122, '@out', 'pixel_count').
annotation(69, 1, 130, '@end', 'transform_images').
annotation(70, 1, 134, '@begin', 'log_average_image_intensity').
annotation(71, 1, 135, '@param', 'cassette_id').
annotation(72, 1, 136, '@param', 'sample_id').
annotation(73, 1, 137, '@param', 'frame_number').
annotation(74, 1, 138, '@in', 'corrected_image_path').
annotation(75, 1, 139, '@in', 'total_intensity').
annotation(76, 1, 140, '@in', 'pixel_count').
annotation(77, 1, 141, '@out', 'collection_log').
annotation(78, 1, 141, '@uri', 'file:run/collected_images.csv').
annotation(79, 1, 149, '@end', 'log_average_image_intensity').
annotation(80, 1, 153, '@end', 'simulate_data_collection').
annotation(81, 1, 157, '@begin', 'collect_next_image').
annotation(82, 1, 158, '@param', 'cassette_id').
annotation(83, 1, 159, '@param', 'sample_id').
annotation(84, 1, 160, '@param', 'num_images').
annotation(85, 1, 161, '@param', 'energies').
annotation(86, 1, 162, '@param', 'image_path_template').
annotation(87, 1, 163, '@return', 'energy').
annotation(88, 1, 164, '@return', 'frame_number').
annotation(89, 1, 165, '@return', 'intensity').
annotation(90, 1, 166, '@return', 'raw_image_path').
annotation(91, 1, 179, '@end', 'collect_next_image').
annotation(92, 1, 183, '@begin', 'transform_image').
annotation(93, 1, 184, '@param', 'raw_image_path').
annotation(94, 1, 185, '@param', 'corrected_image_path').
annotation(95, 1, 186, '@param', 'calibration_image_path').
annotation(96, 1, 187, '@return', 'total_intensity').
annotation(97, 1, 188, '@return', 'pixel_count').
annotation(98, 1, 209, '@end', 'transform_image').

% FACT: annotation_description(annotation_id, annotation_description).

% FACT: annotation_qualifies(qualifying_annotation_id, primary_annotation_id).
annotation_qualifies(5, 4).
annotation_qualifies(7, 6).
annotation_qualifies(9, 8).
annotation_qualifies(11, 10).
annotation_qualifies(13, 12).
annotation_qualifies(15, 14).
annotation_qualifies(18, 17).
annotation_qualifies(23, 22).
annotation_qualifies(40, 39).
annotation_qualifies(52, 51).
annotation_qualifies(53, 51).
annotation_qualifies(61, 60).
annotation_qualifies(63, 62).
annotation_qualifies(65, 64).
annotation_qualifies(78, 77).
