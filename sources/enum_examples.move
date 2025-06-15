//==============================================================
//THIS CODE CONTAINS ALL ABOUT USING ENUM IN MOVE LANGUAGE
//==============================================================

#[allow(duplicate_alias)]
module move_tutorials::comprehensive_enum_demo {
    use std::string::{Self, String};
    use std::vector;

    // ============= BASIC ENUM DEFINITIONS =============
    
    /// Simple enum without data - useful for state machines
    /// This represents different states an entity can be in
    public enum Status has drop {
        Active,      // Entity is currently working
        Inactive,    // Entity is stopped
        Pending,     // Entity is waiting for something
        Suspended    // Entity is temporarily disabled
    }

    /// Enum with mixed variant types - demonstrates all possible patterns
    /// This represents different actions a game character can perform
    public enum Action has drop {
        Stop,                           // Unit variant - no additional data
        Pause { duration: u32 },        // Struct-like variant with named field
        MoveTo { x: u32, y: u32 },     // Multiple named fields
        Jump(u64),                     // Tuple variant with one field
        Teleport(u32, u32, u32),       // Tuple variant with multiple fields (x,y,z)
        ComplexMove {                   // Complex struct variant with multiple types
            path: vector<u32>,
            speed: u64,
            description: String
        }
    }

    /// Generic enum for error handling - common pattern in Move
    /// T represents the success type, String represents error message
    public enum Result<T> has drop {
        Ok(T),           // Success case containing the result
        Error(String)    // Error case containing error message
    }

    /// Generic enum for optional values - alternative to Option pattern
    /// T represents the type that might or might not exist
    public enum Maybe<T> has drop {
        Some(T),    // Value exists
        None        // No value
    }

    // ============= PACKING FUNCTIONS (CONSTRUCTORS) =============

    /// Method 1: Direct construction - simplest approach
    /// Use when: Creating enums in straightforward scenarios
    /// This directly creates a Status enum with Active variant
    public fun create_status_direct(): Status {
        Status::Active
    }

    /// This directly creates an Action enum with MoveTo variant
    public fun create_action_direct(): Action {
        Action::MoveTo { x: 10, y: 20 }
    }

    /// Method 2: Conditional packing based on parameters
    /// Use when: Logic determines which variant to create
    /// This function decides which Status variant to create based on boolean inputs
    public fun create_status_conditional(is_active: bool, is_pending: bool): Status {
        if (is_active) {
            Status::Active
        } else if (is_pending) {
            Status::Pending
        } else {
            Status::Inactive
        }
    }

    /// Method 3: Factory functions for complex variants
    /// Use when: Need validation or complex initialization logic
    /// This creates a ComplexMove action but validates inputs first
    public fun create_complex_move(coordinates: vector<u32>, speed: u64): Action {
        assert!(vector::length(&coordinates) > 0, 1001);  // Ensure path isn't empty
        assert!(speed > 0, 1002);                         // Ensure speed is valid
        
        Action::ComplexMove {
            path: coordinates,
            speed,
            description: string::utf8(b"Automated complex movement")
        }
    }

    /// Method 4: Result-based packing for error handling
    /// Use when: Operations might fail and need error context
    /// This performs division but returns Result enum to handle division by zero
    public fun safe_divide(numerator: u64, denominator: u64): Result<u64> {
        if (denominator == 0) {
            Result::Error(string::utf8(b"Division by zero"))
        } else {
            Result::Ok(numerator / denominator)
        }
    }

    /// Method 5: Builder pattern for complex enums
    /// Use when: Multiple optional parameters or step-by-step construction
    /// This struct helps build Action enums step by step
    public struct ActionBuilder has drop {
        action_type: u8,     // Determines which Action variant to build
        x: u32,              // X coordinate for MoveTo
        y: u32,              // Y coordinate for MoveTo
        jump_height: u64,    // Height for Jump action
        path: vector<u32>,   // Path for ComplexMove
        speed: u64           // Speed for ComplexMove
    }

    /// Creates a new empty ActionBuilder
    public fun new_action_builder(): ActionBuilder {
        ActionBuilder {
            action_type: 0,
            x: 0,
            y: 0,
            jump_height: 0,
            path: vector::empty(),
            speed: 1
        }
    }

    /// Configures the builder to create a MoveTo action
    public fun set_move_to(builder: &mut ActionBuilder, x: u32, y: u32) {
        builder.action_type = 1;
        builder.x = x;
        builder.y = y;
    }

    /// Configures the builder to create a Jump action
    public fun set_jump(builder: &mut ActionBuilder, height: u64) {
        builder.action_type = 2;
        builder.jump_height = height;
    }

    /// Actually creates the Action enum from the builder configuration
    public fun build_action(builder: ActionBuilder): Action {
        let ActionBuilder { action_type, x, y, jump_height, path: _path, speed: _speed } = builder;
        if (action_type == 1) {
            Action::MoveTo { x, y }
        } else if (action_type == 2) {
            Action::Jump(jump_height)
        } else {
            Action::Stop
        }
    }

    // ============= UNPACKING FUNCTIONS (PATTERN MATCHING) =============

    /// Method 1: Simple match - extracts and uses data immediately
    /// Use when: Simple operations on enum variants
    /// This function takes an Action and returns a description string
    public fun execute_action_simple(action: Action): String {
        match (action) {
            Action::Stop => string::utf8(b"Stopped"),
            Action::Pause { duration } => {
                // Format duration into string - in practice you'd use format functions
                let _formatted_duration = duration; // Use the duration value
                string::utf8(b"Paused for specified duration")
            },
            Action::MoveTo { x, y } => {
                // Format coordinates into string - in practice you'd use format functions
                let _formatted_x = x;
                let _formatted_y = y;
                string::utf8(b"Moving to specified coordinates")
            },
            Action::Jump(height) => {
                // Format height into string - in practice you'd use format functions
                let _formatted_height = height;
                string::utf8(b"Jumping to specified height")
            },
            Action::Teleport(x, y, z) => {
                // All three coordinates are available
                let _formatted_x = x;
                let _formatted_y = y;
                let _formatted_z = z;
                string::utf8(b"Teleporting to 3D coordinates")
            },
            Action::ComplexMove { path, speed, description } => {
                // Use all fields to demonstrate they're accessible
                let _path_length = vector::length(&path);
                let _movement_speed = speed;
                description
            }
        }
    }

    /// Method 2: Conditional unpacking with calculations
    /// Use when: Only interested in specific variants or need to compute values
    /// This calculates a "distance" value based on the action type
    public fun get_movement_distance(action: &Action): u64 {
        match (action) {
            Action::MoveTo { x, y } => {
                // Manhattan distance calculation
                (*x as u64) + (*y as u64)
            },
            Action::Jump(height) => *height,
            Action::Teleport(x, y, z) => {
                // Sum all coordinates as a simple distance measure
                (*x as u64) + (*y as u64) + (*z as u64)
            },
            Action::ComplexMove { path, speed: _speed, description: _description } => {
                // Use path length as distance, explicitly ignore speed and description
                vector::length(path)
            },
            Action::Stop => 0,
            Action::Pause { duration: _duration } => 0 // No movement during pause
        }
    }

    /// Method 3: Destructuring with guards and complex logic
    /// Use when: Need complex validation or computation on unpacked data
    /// This validates actions and returns Result indicating success or failure
    public fun validate_and_execute_action(action: Action): Result<String> {
        match (action) {
            Action::Stop => Result::Ok(string::utf8(b"Safe stop executed")),
            
            Action::Pause { duration } => {
                if (duration > 3600) { // More than 1 hour is too long
                    Result::Error(string::utf8(b"Pause duration too long"))
                } else {
                    Result::Ok(string::utf8(b"Pause executed"))
                }
            },
            
            Action::MoveTo { x, y } => {
                if (x > 1000 || y > 1000) { // Coordinates out of game bounds
                    Result::Error(string::utf8(b"Coordinates out of bounds"))
                } else {
                    Result::Ok(string::utf8(b"Move executed"))
                }
            },
            
            Action::Jump(height) => {
                if (height == 0) {
                    Result::Error(string::utf8(b"Invalid jump height"))
                } else if (height > 100) {
                    Result::Error(string::utf8(b"Jump too high"))
                } else {
                    Result::Ok(string::utf8(b"Jump executed"))
                }
            },
            
            Action::Teleport(x, y, z) => {
                if (x == 0 && y == 0 && z == 0) {
                    Result::Error(string::utf8(b"Cannot teleport to origin"))
                } else {
                    Result::Ok(string::utf8(b"Teleport executed"))
                }
            },
            
            Action::ComplexMove { path, speed, description: _description } => {
                if (vector::is_empty(&path)) {
                    Result::Error(string::utf8(b"Empty path provided"))
                } else if (speed == 0) {
                    Result::Error(string::utf8(b"Invalid speed"))
                } else {
                    Result::Ok(string::utf8(b"Complex move executed"))
                }
            }
        }
    }

    /// Method 4: Partial unpacking - only extract what you need
    /// Use when: Large enums but only need specific fields
    /// This assigns priority values to different actions, only using needed fields
    public fun get_action_priority(action: &Action): u8 {
        match (action) {
            Action::Stop => 1,                    // Highest priority
            Action::Teleport(_x, _y, _z) => 2,    // Don't need the coordinates for priority calc
            Action::Jump(_height) => 3,           // Don't need the height for priority calc
            Action::ComplexMove { speed, path: _path, description: _description } => {
                // Only use speed field, ignore path and description
                if (*speed > 10) { 4 } else { 5 }
            },
            Action::MoveTo { x: _x, y: _y } => 6,    // Don't need coordinates for priority
            Action::Pause { duration: _duration } => 7    // Lowest priority
        }
    }

    /// Method 5: Nested enum unpacking
    /// Use when: Working with Result/Option-like patterns
    /// This extracts value from Result or returns default if error
    public fun unwrap_result_or_default<T: copy + drop>(result: Result<T>, default: T): T {
        match (result) {
            Result::Ok(value) => value,
            Result::Error(_error_msg) => default  // Ignore the error message
        }
    }

    /// This checks if a Maybe enum contains a value
    public fun is_some<T>(maybe: &Maybe<T>): bool {
        match (maybe) {
            Maybe::Some(_value) => true,   // Has value, ignore what it is
            Maybe::None => false
        }
    }

    // ============= UTILITY FUNCTIONS =============

    /// Convert enum to string representation
    /// This is useful for debugging or logging
    public fun action_to_string(action: &Action): String {
        match (action) {
            Action::Stop => string::utf8(b"Stop"),
            Action::Pause { duration: _duration } => string::utf8(b"Pause"),
            Action::MoveTo { x: _x, y: _y } => string::utf8(b"MoveTo"),
            Action::Jump(_height) => string::utf8(b"Jump"),
            Action::Teleport(_x, _y, _z) => string::utf8(b"Teleport"),
            Action::ComplexMove { path: _path, speed: _speed, description: _description } => string::utf8(b"ComplexMove")
        }
    }

    /// Check if two actions are the same variant type (not comparing actual data)
    /// This is useful when you want to know if two actions are the same "kind"
    public fun same_action_type(a1: &Action, a2: &Action): bool {
        match (a1) {
            Action::Stop => {
                match (a2) {
                    Action::Stop => true,
                    _ => false
                }
            },
            Action::Pause { duration: _duration1 } => {
                match (a2) {
                    Action::Pause { duration: _duration2 } => true,
                    _ => false
                }
            },
            Action::MoveTo { x: _x1, y: _y1 } => {
                match (a2) {
                    Action::MoveTo { x: _x2, y: _y2 } => true,
                    _ => false
                }
            },
            Action::Jump(_height1) => {
                match (a2) {
                    Action::Jump(_height2) => true,
                    _ => false
                }
            },
            Action::Teleport(_x1, _y1, _z1) => {
                match (a2) {
                    Action::Teleport(_x2, _y2, _z2) => true,
                    _ => false
                }
            },
            Action::ComplexMove { path: _path1, speed: _speed1, description: _desc1 } => {
                match (a2) {
                    Action::ComplexMove { path: _path2, speed: _speed2, description: _desc2 } => true,
                    _ => false
                }
            }
        }
    }

    // ============= ADDITIONAL UTILITY FUNCTIONS =============

    /// Creates a Maybe enum with a value
    public fun some<T>(value: T): Maybe<T> {
        Maybe::Some(value)
    }

    /// Creates an empty Maybe enum
    public fun none<T>(): Maybe<T> {
        Maybe::None
    }

    /// Unwraps a Maybe enum or panics if None
    public fun unwrap<T>(maybe: Maybe<T>): T {
        match (maybe) {
            Maybe::Some(value) => value,
            Maybe::None => abort(1003) // Panic if trying to unwrap None
        }
    }

    /// Safely unwraps a Maybe enum with a default value
    public fun unwrap_or<T: drop>(maybe: Maybe<T>, default: T): T {
        match (maybe) {
            Maybe::Some(value) => value,
            Maybe::None => default
        }
    }

    /// Maps a Maybe<u64> to Maybe<u64> by doubling the value
    /// This is a concrete example since Move doesn't support lambda functions in regular functions
    public fun map_maybe_double(maybe: Maybe<u64>): Maybe<u64> {
        match (maybe) {
            Maybe::Some(value) => Maybe::Some(value * 2),
            Maybe::None => Maybe::None
        }
    }

    /// Test function to demonstrate all enum operations
    public fun test_all_operations(): vector<String> {
        let mut results = vector::empty<String>();
        
        // Test direct creation - actually use the status
        let _status = create_status_direct();
        vector::push_back(&mut results, string::utf8(b"Direct creation works"));
        
        // Test conditional creation - actually use the conditional_status
        let _conditional_status = create_status_conditional(true, false);
        vector::push_back(&mut results, string::utf8(b"Conditional creation works"));
        
        // Test action creation and execution
        let action = create_action_direct();
        let result_string = execute_action_simple(action);
        vector::push_back(&mut results, result_string);
        
        // Test distance calculation - actually use the distance
        let jump_action = Action::Jump(50);
        let _distance = get_movement_distance(&jump_action);
        vector::push_back(&mut results, string::utf8(b"Distance calculation works"));
        
        // Test validation
        let validation_result = validate_and_execute_action(Action::Stop);
        let validation_msg = unwrap_result_or_default(validation_result, string::utf8(b"Default"));
        vector::push_back(&mut results, validation_msg);
        
        // Test Maybe operations
        let maybe_val = some(42u64);
        let is_some_result = is_some(&maybe_val);
        if (is_some_result) {
            vector::push_back(&mut results, string::utf8(b"Maybe operations work"));
        };
        
        // Test map_maybe_double function
        let doubled_maybe = map_maybe_double(some(21u64));
        let doubled_result = unwrap_or(doubled_maybe, 0u64);
        if (doubled_result == 42) {
            vector::push_back(&mut results, string::utf8(b"Map maybe double works"));
        };
        
        results
    }
}