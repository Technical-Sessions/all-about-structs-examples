module move_tutorials::move_tutorials {
    
    use std::string::{Self, String};
    

    // ========================================
    // 1. BASIC STRUCT DEFINITIONS
    // ========================================
    
    // Simple struct with primitive types
    public struct Head has drop {
        eyes: String,
        nose: String,
        mouth: String,
        teeth_count: u8,
        is_healthy: bool,
    }

    // Struct with different data types
    public struct Abdomen has drop {
        stomach: String,
        liver: String,
        spleen: String,
        organs_list: vector<String>,
        weight_kg: u64,
    }

    // Struct with optional fields using Option<T>
    public struct LowerBody has drop {
        legs: String,
        feet: String,
        hands: String,
        shoe_size: Option<u8>,
        hand_span_cm: Option<u16>,
    }

    // ========================================
    // 2. NESTED STRUCTS
    // ========================================
    
    // Struct containing other structs
    public struct Human has drop {
        head: Head,
        abdomen: Abdomen,
        lower_body: LowerBody,
        age: u8,
        name: String,
        id: u64,
    }

    // ========================================
    // 3. STRUCTS WITH ABILITIES
    // ========================================
    
    // Struct with copy ability (can be copied)
    public struct Point has copy, drop {
        x: u64,
        y: u64,
    }

    // Struct with key ability (can be stored as global resource)
    public struct MedicalRecord has key {
        id: UID,
        patient_id: u64,
        diagnosis: String,
        treatment: String,
    }

    // Struct with store ability (can be stored inside other structs)
    public struct Vitals has store, copy, drop {
        heart_rate: u64,
        blood_pressure: String,
        temperature: u64, // in Celsius * 10
    }

    // Struct with all abilities
    public struct HealthData has key, store {
        id: UID,
        vitals: Vitals,
        last_checkup: u64,
        doctor_notes: String,
    }

    // ========================================
    // 4. GENERIC STRUCTS
    // ========================================
    
    // Generic struct with type parameters
    public struct Container<T> has store, drop {
        contents: T,
        label: String,
        size: u64,
    }

    // Generic struct with multiple type parameters
    public struct Pair<T1, T2> has copy, drop, store {
        first: T1,
        second: T2,
    }

    // ========================================
    // 5. CONSTRUCTOR FUNCTIONS (PACKING)
    // ========================================
    
    // Basic constructor
    public fun new_head(
        eyes: String, 
        nose: String, 
        mouth: String,
        teeth_count: u8,
        is_healthy: bool
    ): Head {
        Head {
            eyes,
            nose,
            mouth,
            teeth_count,
            is_healthy,
        }
    }

    // Constructor with default values
    public fun new_head_default(): Head {
        Head {
            eyes: string::utf8(b"Brown"),
            nose: string::utf8(b"Medium"),
            mouth: string::utf8(b"Normal"),
            teeth_count: 32,
            is_healthy: true,
        }
    }

    // Constructor with validation
    public fun new_abdomen_validated(
        stomach: String,
        liver: String,
        spleen: String,
        weight_kg: u64
    ): Abdomen {
        // Validation logic
        assert!(weight_kg > 0 && weight_kg < 200, 1001);
        
        let mut organs = vector::empty<String>();
        vector::push_back(&mut organs, stomach);
        vector::push_back(&mut organs, liver);
        vector::push_back(&mut organs, spleen);

        Abdomen {
            stomach,
            liver,
            spleen,
            organs_list: organs,
            weight_kg,
        }
    }

    // Constructor with optional parameters
    public fun new_lower_body(
        legs: String,
        feet: String,
        hands: String,
        shoe_size: Option<u8>,
        hand_span_cm: Option<u16>
    ): LowerBody {
        LowerBody {
            legs,
            feet,
            hands,
            shoe_size,
            hand_span_cm,
        }
    }

    // Complex constructor with nested structs
    public fun new_human(
        name: String,
        age: u8,
        head: Head,
        abdomen: Abdomen,
        lower_body: LowerBody
    ): Human {
        // Generate unique ID (simplified)
        let id = (age as u64) * 1000 + (string::length(&name) as u64);
        
        Human {
            head,
            abdomen,
            lower_body,
            age,
            name,
            id,
        }
    }

    // Constructor for objects with UID
    public fun new_medical_record(
        patient_id: u64,
        diagnosis: String,
        treatment: String,
        ctx: &mut TxContext
    ): MedicalRecord {
        MedicalRecord {
            id: object::new(ctx),
            patient_id,
            diagnosis,
            treatment,
        }
    }

    // Constructor for health data
    public fun new_health_data(
        heart_rate: u64,
        blood_pressure: String,
        temperature: u64,
        last_checkup: u64,
        doctor_notes: String,
        ctx: &mut TxContext
    ): HealthData {
        let vitals = Vitals {
            heart_rate,
            blood_pressure,
            temperature,
        };

        HealthData {
            id: object::new(ctx),
            vitals,
            last_checkup,
            doctor_notes,
        }
    }

    // ========================================
    // 6. FIELD ACCESS AND MODIFICATION
    // ========================================
    
    // Reading fields with references (no ownership transfer)
    public fun get_human_name(human: &Human): &String {
        &human.name
    }

    public fun get_human_age(human: &Human): u8 {
        human.age
    }

    // Nested field access
    public fun get_eye_color(human: &Human): &String {
        &human.head.eyes
    }

    public fun get_teeth_count(human: &Human): u8 {
        human.head.teeth_count
    }

    // Point field access
    public fun get_point_coordinates(point: &Point): (u64, u64) {
        (point.x, point.y)
    }

    public fun get_distance_from_origin(point: &Point): u64 {
        // Simplified distance calculation (not actual Euclidean distance)
        point.x + point.y
    }

    // Vitals field access
    public fun get_heart_rate(vitals: &Vitals): u64 {
        vitals.heart_rate
    }

    public fun get_temperature_celsius(vitals: &Vitals): u64 {
        vitals.temperature / 10 // Convert from stored format
    }

    public fun is_fever(vitals: &Vitals): bool {
        vitals.temperature > 380 // 38.0 Celsius
    }

    // Health data field access
    public fun get_patient_vitals(health_data: &HealthData): &Vitals {
        &health_data.vitals
    }

    public fun get_last_checkup(health_data: &HealthData): u64 {
        health_data.last_checkup
    }

    // Mutable field access and modification
    public fun update_age(human: &mut Human, new_age: u8) {
        human.age = new_age;
    }

    public fun update_eye_color(human: &mut Human, new_eyes: String) {
        human.head.eyes = new_eyes;
    }

    // Complex field modifications
    public fun add_organ_to_list(human: &mut Human, organ: String) {
        vector::push_back(&mut human.abdomen.organs_list, organ);
    }

    public fun set_shoe_size(human: &mut Human, size: u8) {
        human.lower_body.shoe_size = option::some(size);
    }

    // Point modifications
    public fun move_point(point: &mut Point, dx: u64, dy: u64) {
        point.x = point.x + dx;
        point.y = point.y + dy;
    }

    // Vitals modifications
    public fun update_vitals(
        vitals: &mut Vitals,
        heart_rate: u64,
        blood_pressure: String,
        temperature: u64
    ) {
        vitals.heart_rate = heart_rate;
        vitals.blood_pressure = blood_pressure;
        vitals.temperature = temperature;
    }

    // ========================================
    // 7. DESTRUCTURING (UNPACKING)
    // ========================================
    
    // Complete destructuring
    public fun unpack_head(head: Head): (String, String, String, u8, bool) {
        let Head { eyes, nose, mouth, teeth_count, is_healthy } = head;
        (eyes, nose, mouth, teeth_count, is_healthy)
    }

    // Partial destructuring (ignoring some fields)
    public fun get_basic_head_info(head: Head): (String, String) {
        let Head { eyes, nose, mouth: _, teeth_count: _, is_healthy: _ } = head;
        (eyes, nose)
    }

    // Reference destructuring (no ownership transfer)
    public fun read_head_info(head: &Head): (&String, &String, u8) {
        let Head { eyes, nose, mouth: _, teeth_count, is_healthy: _ } = head;
        (eyes, nose, *teeth_count)
    }

    // Point destructuring
    public fun unpack_point(point: Point): (u64, u64) {
        let Point { x, y } = point;
        (x, y)
    }

    // Vitals destructuring
    public fun unpack_vitals(vitals: Vitals): (u64, String, u64) {
        let Vitals { heart_rate, blood_pressure, temperature } = vitals;
        (heart_rate, blood_pressure, temperature)
    }

    // Nested destructuring
    public fun unpack_human_basic(human: Human): (String, u8, String, String) {
        let Human { 
            head,
            abdomen: _,
            lower_body: _,
            age,
            name,
            id: _
        } = human;
        
        let Head { eyes, nose: _, mouth: _, teeth_count: _, is_healthy: _ } = head;
        (name, age, eyes, string::utf8(b"unpacked"))
    }

    // Conditional destructuring with pattern matching
    public fun check_shoe_size(human: &Human): String {
        let shoe_size = &human.lower_body.shoe_size;
        if (option::is_some(shoe_size)) {
            let size = *option::borrow(shoe_size);
            if (size > 10) {
                string::utf8(b"Large feet")
            } else {
                string::utf8(b"Normal feet")
            }
        } else {
            string::utf8(b"Unknown shoe size")
        }
    }

    // ========================================
    // 8. STRUCT METHODS AND ASSOCIATED FUNCTIONS
    // ========================================
    
    // Associated function (like static method)
    public fun create_baby(): Human {
        let baby_head = new_head(
            string::utf8(b"Blue"),
            string::utf8(b"Small"),
            string::utf8(b"Tiny"),
            0,
            true
        );
        
        let baby_abdomen = new_abdomen_validated(
            string::utf8(b"Small stomach"),
            string::utf8(b"Developing liver"),
            string::utf8(b"Small spleen"),
            3
        );
        
        let baby_lower_body = new_lower_body(
            string::utf8(b"Short legs"),
            string::utf8(b"Tiny feet"),
            string::utf8(b"Small hands"),
            option::none(),
            option::none()
        );

        new_human(
            string::utf8(b"Baby"),
            0,
            baby_head,
            baby_abdomen,
            baby_lower_body
        )
    }

    // Create point at origin
    public fun create_origin(): Point {
        Point { x: 0, y: 0 }
    }

    // Create point at specific coordinates
    public fun create_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    // Create normal vitals
    public fun create_normal_vitals(): Vitals {
        Vitals {
            heart_rate: 70,
            blood_pressure: string::utf8(b"120/80"),
            temperature: 370, // 37.0 Celsius
        }
    }

    // Method-like functions that take self as first parameter
    public fun is_adult(human: &Human): bool {
        human.age >= 18
    }

    public fun celebrate_birthday(human: &mut Human) {
        human.age = human.age + 1;
    }

    public fun get_bmi_category(human: &Human): String {
        let weight = human.abdomen.weight_kg;
        // Simplified BMI calculation (assuming average height)
        if (weight < 50) {
            string::utf8(b"Underweight")
        } else if (weight > 90) {
            string::utf8(b"Overweight")
        } else {
            string::utf8(b"Normal")
        }
    }

    // ========================================
    // 9. GENERIC STRUCT OPERATIONS
    // ========================================
    
    public fun create_container<T>(contents: T, label: String): Container<T> {
        Container {
            contents,
            label,
            size: 1,
        }
    }

    public fun get_container_contents<T>(container: Container<T>): T {
        let Container { contents, label: _, size: _ } = container;
        contents
    }

    public fun get_container_info<T>(container: &Container<T>): (&String, u64) {
        (&container.label, container.size)
    }

    public fun create_pair<T1: copy, T2: copy>(first: T1, second: T2): Pair<T1, T2> {
        Pair { first, second }
    }

    public fun swap_pair<T1: copy, T2: copy>(pair: Pair<T1, T2>): Pair<T2, T1> {
        let Pair { first, second } = pair;
        Pair { first: second, second: first }
    }

    public fun get_first<T1: copy, T2>(pair: &Pair<T1, T2>): T1 {
        pair.first
    }

    public fun get_second<T1, T2: copy>(pair: &Pair<T1, T2>): T2 {
        pair.second
    }

    // ========================================
    // 10. STRUCT COPYING AND CLONING
    // ========================================
    
    public fun copy_point(point: &Point): Point {
        *point // Point has copy ability, so we can dereference
    }

    public fun clone_vitals(vitals: &Vitals): Vitals {
        *vitals // Vitals has copy ability
    }

    // Manual cloning for structs without copy ability
    public fun clone_head(head: &Head): Head {
        Head {
            eyes: head.eyes,
            nose: head.nose,
            mouth: head.mouth,
            teeth_count: head.teeth_count,
            is_healthy: head.is_healthy,
        }
    }

    // ========================================
    // 11. STRUCT COMPARISON AND EQUALITY
    // ========================================
    
    public fun compare_ages(human1: &Human, human2: &Human): bool {
        human1.age == human2.age
    }

    public fun is_same_eye_color(human1: &Human, human2: &Human): bool {
        human1.head.eyes == human2.head.eyes
    }

    // Point comparison
    public fun points_equal(p1: &Point, p2: &Point): bool {
        p1.x == p2.x && p1.y == p2.y
    }

    // Vitals comparison
    public fun vitals_equal(v1: &Vitals, v2: &Vitals): bool {
        v1.heart_rate == v2.heart_rate &&
        v1.blood_pressure == v2.blood_pressure &&
        v1.temperature == v2.temperature
    }

    // Manual equality check for complex structs
    public fun heads_equal(head1: &Head, head2: &Head): bool {
        head1.eyes == head2.eyes &&
        head1.nose == head2.nose &&
        head1.mouth == head2.mouth &&
        head1.teeth_count == head2.teeth_count &&
        head1.is_healthy == head2.is_healthy
    }

    // ========================================
    // 12. VECTOR OF STRUCTS
    // ========================================
    
    public fun create_population(): vector<Human> {
        let mut population = vector::empty<Human>();
        
        // Add multiple humans
        let person1 = create_baby();
        let person2 = create_baby();
        
        vector::push_back(&mut population, person1);
        vector::push_back(&mut population, person2);
        
        population
    }

    public fun create_point_grid(width: u64, height: u64): vector<Point> {
        let mut points = vector::empty<Point>();
        let mut x = 0;
        
        while (x < width) {
            let mut y = 0;
            while (y < height) {
                vector::push_back(&mut points, create_point(x, y));
                y = y + 1;
            };
            x = x + 1;
        };
        
        points
    }

    public fun find_oldest_human(humans: &vector<Human>): Option<u8> {
        if (vector::is_empty(humans)) {
            return option::none()
        };
        
        let mut max_age = 0u8;
        let mut i = 0;
        let len = vector::length(humans);
        
        while (i < len) {
            let human = vector::borrow(humans, i);
            if (human.age > max_age) {
                max_age = human.age;
            };
            i = i + 1;
        };
        
        option::some(max_age)
    }

    // ========================================
    // 13. ERROR HANDLING WITH STRUCTS
    // ========================================
    
     const E_INVALID_AGE: u64 = 1001;
     const E_INVALID_WEIGHT: u64 = 1002;
     const E_EMPTY_NAME: u64 = 1003;

    public fun create_human_safe(
        name: String,
        age: u8,
        weight_kg: u64
    ): Human {
        // Validation
        assert!(!string::is_empty(&name), E_EMPTY_NAME);
        assert!(age <= 150, E_INVALID_AGE);
        assert!(weight_kg > 0 && weight_kg < 500, E_INVALID_WEIGHT);
        
        let head = new_head_default();
        let abdomen = new_abdomen_validated(
            string::utf8(b"Normal stomach"),
            string::utf8(b"Healthy liver"),
            string::utf8(b"Normal spleen"),
            weight_kg
        );
        let lower_body = new_lower_body(
            string::utf8(b"Strong legs"),
            string::utf8(b"Normal feet"),
            string::utf8(b"Steady hands"),
            option::none(),
            option::none()
        );

        new_human(name, age, head, abdomen, lower_body)
    }

    // ========================================
    // 14. ADDITIONAL UTILITY FUNCTIONS
    // ========================================
    
    // Utility function for debugging
    public fun debug_human_info(human: &Human): vector<String> {
        let mut info = vector::empty<String>();
        vector::push_back(&mut info, *get_human_name(human));
        vector::push_back(&mut info, *get_eye_color(human));
        info
    }

    // Utility function for medical records
    public fun is_healthy_human(human: &Human): bool {
        human.head.is_healthy && human.abdomen.weight_kg > 0
    }
}