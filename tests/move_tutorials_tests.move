
#[test_only]
module move_tutorials::move_tutorials_tests {
    use move_tutorials::move_tutorials::{
        // Import constructor functions
        new_head, create_baby, create_point, create_normal_vitals,
        create_container, create_pair,
        
        // Import field access functions
        get_human_name, get_human_age, get_eye_color, get_teeth_count,
        get_point_coordinates, get_heart_rate, get_temperature_celsius,
        get_container_contents, get_first, get_second,
        
        // Import modification functions
        update_age, update_eye_color, set_shoe_size, move_point, update_vitals,
        celebrate_birthday, is_adult,
        
        // Import utility functions
        unpack_head, swap_pair, is_fever, points_equal, vitals_equal,
        create_population, create_point_grid, find_oldest_human,
        compare_ages, is_same_eye_color, heads_equal, get_bmi_category,
        check_shoe_size, is_healthy_human, debug_human_info
    };
    use std::string;
    

    // ========================================
    // BASIC STRUCT OPERATIONS TESTS
    // ========================================
    
    #[test]
    public fun test_basic_struct_operations() {
        // Test packing
        let head = new_head(
            string::utf8(b"Green"),
            string::utf8(b"Sharp"),
            string::utf8(b"Wide"),
            28,
            true
        );

        // Test unpacking - get the values we need before consuming the head
        let (eyes, nose, mouth, teeth, healthy) = unpack_head(head);
        
        // Test the unpacked values
        assert!(eyes == string::utf8(b"Green"), 1);
        assert!(nose == string::utf8(b"Sharp"), 2);
        assert!(mouth == string::utf8(b"Wide"), 3);
        assert!(teeth == 28, 4);
        assert!(healthy == true, 5);
        
        // Create a human to test get_teeth_count (since it expects &Human, not &Head)
        let human = create_baby();
        let teeth_count = get_teeth_count(&human);
        assert!(teeth_count == 0, 6); // Baby has 0 teeth
    }

    #[test]
    public fun test_head_constructor_variations() {
        // Test basic constructor
        let head1 = new_head(
            string::utf8(b"Blue"),
            string::utf8(b"Long"),
            string::utf8(b"Small"),
            32,
            true
        );
        
        // Test field access after construction via unpacking
        let (eyes, nose, mouth, teeth, healthy) = unpack_head(head1);
        assert!(eyes == string::utf8(b"Blue"), 1);
        assert!(nose == string::utf8(b"Long"), 2);
        assert!(mouth == string::utf8(b"Small"), 3);
        assert!(teeth == 32, 4);
        assert!(healthy == true, 5);
    }

    // ========================================
    // NESTED STRUCTS TESTS
    // ========================================
    
    #[test]
    public fun test_nested_structs() {
        let human = create_baby();
        
        // Test nested field access via getter functions
        let name = get_human_name(&human);
        assert!(*name == string::utf8(b"Baby"), 1);
        
        let age = get_human_age(&human);
        assert!(age == 0, 2);
        
        let eyes = get_eye_color(&human);
        assert!(*eyes == string::utf8(b"Blue"), 3);
    }

    #[test]
    public fun test_human_creation_and_access() {
        let human = create_baby();
        
        // Test all basic accessors
        assert!(get_human_age(&human) == 0, 1);
        assert!(*get_human_name(&human) == string::utf8(b"Baby"), 2);
        assert!(*get_eye_color(&human) == string::utf8(b"Blue"), 3);
        
        // Test that baby has expected characteristics via getter functions
        let teeth_count = get_teeth_count(&human);
        assert!(teeth_count == 0, 4); // Babies have no teeth
        assert!(is_healthy_human(&human), 5); // Use utility function instead of direct access
    }

    // ========================================
    // POINT OPERATIONS TESTS
    // ========================================
    
    #[test]
    public fun test_point_operations() {
        let mut point = create_point(5, 10);
        let (x, y) = get_point_coordinates(&point);
        assert!(x == 5 && y == 10, 1);

        move_point(&mut point, 3, 4);
        let (new_x, new_y) = get_point_coordinates(&point);
        assert!(new_x == 8 && new_y == 14, 2);

        let distance = move_tutorials::move_tutorials::get_distance_from_origin(&point);
        assert!(distance == 22, 3);
    }

    #[test]
    public fun test_point_creation_and_manipulation() {
        // Test origin creation
        let origin = move_tutorials::move_tutorials::create_origin();
        let (x, y) = get_point_coordinates(&origin);
        assert!(x == 0 && y == 0, 1);

        // Test custom point creation
        let mut custom_point = create_point(100, 200);
        let (x, y) = get_point_coordinates(&custom_point);
        assert!(x == 100 && y == 200, 2);

        // Test point movement
        move_point(&mut custom_point, 50, 25);
        let (new_x, new_y) = get_point_coordinates(&custom_point);
        assert!(new_x == 150 && new_y == 225, 3);
    }

    #[test]
    public fun test_point_copying() {
        let original = create_point(7, 14);
        let copied = move_tutorials::move_tutorials::copy_point(&original);
        
        assert!(points_equal(&original, &copied), 1);
        
        let (orig_x, orig_y) = get_point_coordinates(&original);
        let (copy_x, copy_y) = get_point_coordinates(&copied);
        assert!(orig_x == copy_x && orig_y == copy_y, 2);
    }

    // ========================================
    // VITALS OPERATIONS TESTS
    // ========================================
    
    #[test]
    public fun test_vitals_operations() {
        let mut vitals = create_normal_vitals();
        assert!(get_heart_rate(&vitals) == 70, 1);
        assert!(get_temperature_celsius(&vitals) == 37, 2);
        assert!(!is_fever(&vitals), 3);

        update_vitals(&mut vitals, 80, string::utf8(b"130/85"), 390);
        assert!(is_fever(&vitals), 4);
    }

    #[test]
    public fun test_vitals_fever_detection() {
        let mut vitals = create_normal_vitals();
        
        // Normal temperature - no fever
        assert!(!is_fever(&vitals), 1);
        assert!(get_temperature_celsius(&vitals) == 37, 2);

        // High temperature - fever
        update_vitals(&mut vitals, 85, string::utf8(b"140/90"), 390); // 39.0 Celsius
        assert!(is_fever(&vitals), 3);
        assert!(get_temperature_celsius(&vitals) == 39, 4);

        // Very high temperature - definitely fever
        update_vitals(&mut vitals, 90, string::utf8(b"150/95"), 410); // 41.0 Celsius
        assert!(is_fever(&vitals), 5);
    }

    #[test]
    public fun test_vitals_cloning() {
        let original = create_normal_vitals();
        let cloned = move_tutorials::move_tutorials::clone_vitals(&original);
        
        assert!(vitals_equal(&original, &cloned), 1);
        assert!(get_heart_rate(&original) == get_heart_rate(&cloned), 2);
        assert!(get_temperature_celsius(&original) == get_temperature_celsius(&cloned), 3);
    }

    // ========================================
    // GENERIC STRUCTS TESTS
    // ========================================
    
    #[test]
    public fun test_generic_structs() {
        // Test generic container
        let container = create_container(42u64, string::utf8(b"Number Container"));
        let contents = get_container_contents(container);
        assert!(contents == 42, 1);

        // Test generic pair
        let pair = create_pair(string::utf8(b"Hello"), 100u8);
        let swapped = swap_pair(pair);
        let first_value = get_first(&swapped);
        assert!(first_value == 100, 2);
    }

    #[test]
    public fun test_container_operations() {
        // Test string container
        let str_container = create_container(
            string::utf8(b"Hello World"), 
            string::utf8(b"String Container")
        );
        let (label, size) = move_tutorials::move_tutorials::get_container_info(&str_container);
        assert!(*label == string::utf8(b"String Container"), 1);
        assert!(size == 1, 2);

        // Test number container
        let num_container = create_container(999u64, string::utf8(b"Big Number"));
        let number = get_container_contents(num_container);
        assert!(number == 999, 3);
    }

    #[test]
    public fun test_pair_operations() {
        // Test basic pair creation and swapping
        let original_pair = create_pair(string::utf8(b"First"), string::utf8(b"Second"));
        let first = get_first(&original_pair);
        let second = get_second(&original_pair);
        
        assert!(first == string::utf8(b"First"), 1);
        assert!(second == string::utf8(b"Second"), 2);

        // Test swapping
        let swapped = swap_pair(original_pair);
        let swapped_first = get_first(&swapped);
        let swapped_second = get_second(&swapped);
        
        assert!(swapped_first == string::utf8(b"Second"), 3);
        assert!(swapped_second == string::utf8(b"First"), 4);
    }

    #[test]
    public fun test_mixed_type_pairs() {
        // Test pair with different types
        let mixed_pair = create_pair(42u64, string::utf8(b"Answer"));
        let number = get_first(&mixed_pair);
        let text = get_second(&mixed_pair);
        
        assert!(number == 42, 1);
        assert!(text == string::utf8(b"Answer"), 2);

        // Test swapping mixed types
        let swapped = swap_pair(mixed_pair);
        let swapped_text = get_first(&swapped);
        let swapped_number = get_second(&swapped);
        
        assert!(swapped_text == string::utf8(b"Answer"), 3);
        assert!(swapped_number == 42, 4);
    }

    // ========================================
    // VECTOR OPERATIONS TESTS
    // ========================================
    
    #[test]
    #[allow(duplicate_alias)]
    public fun test_struct_vectors() {
        use std::vector;
        
        let population = create_population();
        assert!(vector::length(&population) == 2, 1);
        
        let mut oldest_age_opt = find_oldest_human(&population);
        assert!(option::is_some(&oldest_age_opt), 2); // Check if option contains a value
        
        let oldest_age = option::extract(&mut oldest_age_opt);
        assert!(oldest_age == 0, 3); // Both babies have age 0
    }

    #[test]
    #[allow(duplicate_alias)]
    public fun test_point_grid_creation() {
        use std::vector;
        
        // Test small grid
        let small_grid = create_point_grid(2, 3);
        assert!(vector::length(&small_grid) == 6, 1);

        // Test single point grid
        let single_grid = create_point_grid(1, 1);
        assert!(vector::length(&single_grid) == 1, 2);
        
        let point = vector::borrow(&single_grid, 0);
        let (x, y) = get_point_coordinates(point);
        assert!(x == 0 && y == 0, 3);

        // Test larger grid
        let large_grid = create_point_grid(5, 4);
        assert!(vector::length(&large_grid) == 20, 4);
    }

    #[test]
    #[allow(duplicate_alias)]
    public fun test_population_age_finding() {
        use std::vector;
        
        // Create custom population with different ages
        let mut custom_population = vector::empty();
        
        let baby = create_baby(); // age 0
        vector::push_back(&mut custom_population, baby);
        
        // We need to create humans with different ages through safe creation
        let adult = move_tutorials::move_tutorials::create_human_safe(
            string::utf8(b"Adult"),
            25,
            70
        );
        vector::push_back(&mut custom_population, adult);

        let senior = move_tutorials::move_tutorials::create_human_safe(
            string::utf8(b"Senior"),
            65,
            80
        );
        vector::push_back(&mut custom_population, senior);

        let mut oldest_age_opt = find_oldest_human(&custom_population);
        assert!(option::is_some(&oldest_age_opt), 1);
        
        let oldest_age = option::extract(&mut oldest_age_opt);
        assert!(oldest_age == 65, 2); // Senior is oldest at 65
    }

    // ========================================
    // MUTABLE OPERATIONS TESTS
    // ========================================
    
    #[test]
    public fun test_mutable_operations() {
        let mut human = create_baby();
        
        // Test mutable updates
        update_age(&mut human, 25);
        assert!(get_human_age(&human) == 25, 1);
        
        update_eye_color(&mut human, string::utf8(b"Hazel"));
        assert!(*get_eye_color(&human) == string::utf8(b"Hazel"), 2);
        
        set_shoe_size(&mut human, 10);
        // Test shoe size through utility function
        let shoe_info = check_shoe_size(&human);
        assert!(shoe_info == string::utf8(b"Normal feet"), 3);
    }

    #[test]
    public fun test_human_aging() {
        let mut human = create_baby();
        assert!(get_human_age(&human) == 0, 1);
        
        // Age the human multiple times
        celebrate_birthday(&mut human);
        assert!(get_human_age(&human) == 1, 2);
        
        celebrate_birthday(&mut human);
        assert!(get_human_age(&human) == 2, 3);
        
        // Direct age update
        update_age(&mut human, 30);
        assert!(get_human_age(&human) == 30, 4);
        
        // Test adult status
        assert!(is_adult(&human), 5);
    }

    #[test]
    public fun test_human_modifications() {
        let mut human = create_baby();
        
        // Test eye color change
        update_eye_color(&mut human, string::utf8(b"Green"));
        assert!(*get_eye_color(&human) == string::utf8(b"Green"), 1);
        
        // Test organ addition
        move_tutorials::move_tutorials::add_organ_to_list(&mut human, string::utf8(b"Heart"));
        // We can't easily test this without exposing the organs list, but it shouldn't panic
        
        // Test shoe size setting
        set_shoe_size(&mut human, 9);
        let shoe_info = check_shoe_size(&human);
        assert!(shoe_info == string::utf8(b"Normal feet"), 2);
        
        // Test that human is still healthy after modifications
        assert!(is_healthy_human(&human), 3);
    }

    // ========================================
    // EQUALITY AND COMPARISON TESTS
    // ========================================
    
    #[test]
    public fun test_struct_equality() {
        let point1 = create_point(5, 10);
        let point2 = create_point(5, 10);
        let point3 = create_point(3, 7);

        assert!(points_equal(&point1, &point2), 1);
        assert!(!points_equal(&point1, &point3), 2);

        let vitals1 = create_normal_vitals();
        let vitals2 = create_normal_vitals();
        assert!(vitals_equal(&vitals1, &vitals2), 3);
    }

    #[test]
    public fun test_human_comparisons() {
        let human1 = create_baby();
        let human2 = create_baby();
        
        // Test age comparison
        assert!(compare_ages(&human1, &human2), 1);
        
        // Test eye color comparison
        assert!(is_same_eye_color(&human1, &human2), 2);
        
        // Create human with different eye color
        let mut human3 = create_baby();
        update_eye_color(&mut human3, string::utf8(b"Brown"));
        assert!(!is_same_eye_color(&human1, &human3), 3);
    }

    #[test]
    public fun test_head_equality() {
        let head1 = new_head(
            string::utf8(b"Blue"),
            string::utf8(b"Small"),
            string::utf8(b"Normal"),
            28,
            true
        );
        
        let head2 = new_head(
            string::utf8(b"Blue"),
            string::utf8(b"Small"),
            string::utf8(b"Normal"),
            28,
            true
        );
        
        let head3 = new_head(
            string::utf8(b"Green"), // Different eye color
            string::utf8(b"Small"),
            string::utf8(b"Normal"),
            28,
            true
        );
        
        assert!(heads_equal(&head1, &head2), 1);
        assert!(!heads_equal(&head1, &head3), 2);
    }

    // ========================================
    // ERROR HANDLING TESTS
    // ========================================
    
    #[test]
    public fun test_safe_human_creation() {
        // Test valid human creation
        let human = move_tutorials::move_tutorials::create_human_safe(
            string::utf8(b"Alice"),
            30,
            65
        );
        assert!(*get_human_name(&human) == string::utf8(b"Alice"), 1);
        assert!(get_human_age(&human) == 30, 2);
    }

    #[test]
    #[expected_failure(abort_code = move_tutorials::move_tutorials::E_EMPTY_NAME)]
    public fun test_empty_name_error() {
        move_tutorials::move_tutorials::create_human_safe(
            string::utf8(b""), // Empty name should fail
            25,
            70
        );
    }

    #[test]
    #[expected_failure(abort_code = move_tutorials::move_tutorials::E_INVALID_AGE)]
    public fun test_invalid_age_error() {
        move_tutorials::move_tutorials::create_human_safe(
            string::utf8(b"TooOld"),
            200, // Invalid age should fail
            70
        );
    }

    #[test]
    #[expected_failure(abort_code = move_tutorials::move_tutorials::E_INVALID_WEIGHT)]
    public fun test_invalid_weight_error() {
        move_tutorials::move_tutorials::create_human_safe(
            string::utf8(b"TooHeavy"),
            30,
            600 // Invalid weight should fail
        );
    }

    // ========================================
    // UTILITY FUNCTION TESTS
    // ========================================
    
    #[test]
    public fun test_utility_functions() {
        let human = create_baby();
        
        // Test BMI category
        let bmi_category = get_bmi_category(&human);
        assert!(bmi_category == string::utf8(b"Underweight"), 1); // Baby weight is 3kg
        
        // Test adult status
        assert!(!is_adult(&human), 2); // Baby is not adult
        
        // Test shoe size check
        let shoe_info = check_shoe_size(&human);
        assert!(shoe_info == string::utf8(b"Unknown shoe size"), 3); // Baby has no shoe size set
        
        // Test health status
        assert!(is_healthy_human(&human), 4);
    }

    #[test]
    #[allow(duplicate_alias)]
    public fun test_debug_functions() {
        use std::vector;
        
        let human = create_baby();
        let debug_info = debug_human_info(&human);
        
        assert!(vector::length(&debug_info) == 2, 1);
        assert!(*vector::borrow(&debug_info, 0) == string::utf8(b"Baby"), 2);
        assert!(*vector::borrow(&debug_info, 1) == string::utf8(b"Blue"), 3);
    }
}