# Veto

Veto provides solid, lightweight, validation for plain old ruby objects, using a familiar DSL.


Tested on the following Rubies: MRI 2.0.0.

## Installation

Add this line to your application's Gemfile:

    gem 'veto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install veto

## Basic Usage

Validate an object by passing it to the validator.

    person = Person.new
    validator = PersonValidator.valid?(person) # => false
    
    
If the entity being validated has an `errors` accessor defined, the validator will attempt to assign an errors object on the entity each time it is validated.

    person = Person.new
    person.errors # => nil
    validator = PersonValidator.valid?(person) # => false
    person.errors.full_messages # => ["first name is not present", "last name is not present"]
    
Use the validate bang method for strict validations.

    person = Person.new
    validator = PersonValidator.validate!(person) # => Veto::InvalidEntity, ["first name is not present", "..."]

### Validator Instances

You can perform validations just as easily using a validator instance. This is convenient when you need to obtain errors directly from the validator.

    person = Person.new
    validator = PersonValidator.new(person)
    validator.valid? # => false
    validator.errors.full_messages # => ["first name is not present", "last name is not present"]
    
    
### Validator Model Mixin

In cases where an object will only ever be validated by a single validator, a validator can be embedded directly inside the model using the Veto.model mixin. The mixin will add `valid?`, `validate!` and `errors` methods to your object, and delegate these methods to the validator.

    class Person
        include Veto.model(PersonValidator)
    end
    
    person.new
    person.valid? # => false
    person.errors.full_messages # => ["first name is not present", "last name is not present"]
    person.validate! # => Veto::InvalidEntity, ["first name is not present", "..."]

## Configuration

Create a new validator by including the Veto validator module in your validator class.

    class PersonValidator
        include Veto.validator
    end

### Validation Helpers

#### Presence
Likely the most used validation helper, the `presence` helper will check that the specified object attribute is not blank. Object attributes that are nil, or respond to `empty?` and return true, are considered blank. All other values will be considered present. This means that `presence` helper is safe to use for boolean attributes, where you need to ensure that the attribute value can be true or false, but not nil.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => true
    end

#### Not Null
Similar to the `presence` helper, the `not_null` helper will strictly check that the specified attribute is not null/nil. Any attribute where `nil?` returns true is considered null. Other values, including blank strings and empty arrays, are all considered not-null and will pass.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :not_null => true
    end
    
#### Format
The `format` helper ensures that the string value of an attribute matches the specified regular expression. It's useful for ensuring that email addresses, URLs, UPC codes, ISBN codes, and the like, are in a specific format. It can also be used to check that only certain characters are used in the string.

    class PersonValidator
        include Veto.validator
  
        validates :email, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
        
            # OR
        
        validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  
    end
    
#### Inclusion
This helper ensures that an attribute is included in a specified set, or range of values.

    class PersonValidator
        include Veto.validator
        
        validates :role, :inclusion => [:webmaster, :admin, :user]
        
            # OR
        
        validates :role, :inclusion => { :in => [:webmaster, :admin, :user] }
    end
    
#### Integer
This helper checks that the specified attribute can be a valid integer. For example, the values `123` and `'123'` will both pass, but `123.4` and `'123.4'` will both fail.

    class PersonValidator
        include Veto.validator
        
        validates :age, :integer => true    
    end

#### Numeric
This helper checks that the specified attribute can be a valid float. For example, the values `123.4` and `'123.4'` will both pass.

    class PersonValidator
        include Veto.validator
        
        validates :height, :numeric => true    
    end

#### Exact Length
This helper checks that an attribute is an exact length in characters.

    class BookValidator
        include Veto.validator
        
        validates :isbn, :exact_length => 17
        
            # OR
            
        validates :isbn, :exact_length => { :with => 17 }
    end

#### Max Length
This helper checks that an attribute does not exceed a given maximum character length.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :max_length => 10
        
            # OR
            
        validates :first_name, :max_length => { :with => 10 }
    end

#### Min Length
This helper checks that an attribute is longer than a given minimum character length.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :min_length => 3
        
            # OR
            
        validates :first_name, :min_length => { :with => 3 }
    end

#### Length Range
This helper checks that the length of an attribute falls within a given range, or other object that responds to `include?`

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :length_range => 3..10
        
            # OR
            
        validates :first_name, :length_range => { :in => 3..10 } 
    end

### Common Validation Options
#### Message

The `:message` option allows you to specify the error message that will be added to the errors object when validation fails.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => {:message => "has not been set"}
    end

### Conditional Validation

You may want a validation to be run only when a certain condition is satisfied. To accomplish this, you can pass `if` and `unless` conditional statements to the validators. Passing an `:if` condition to a validator will ensure that the validation is **only** run if the condition returns true. Passing an `:unless` condition to a validator will ensure that the validation is **always** run unless the condition returns true.

#### Using a symbol with :if and :unless

Passing a symbol to the :if or :unless option will call the coorespondition validator method upon validation.

    class PersonValidator
        include Veto.validator
        
        validates :last_name, :presence => true, :if => :first_name_set?
        
        def first_name_set?
            entity.first_name
        end
    end
    
#### Using a proc with :if and :unless

A Proc object passed to an :if or :unless condition will be run during validation. The Proc object will receive the object being validated as a single argument.

    class PersonValidator
        include Veto.validator
        
        validates :last_name, :presence => true, :unless => Proc.new{|person| person.first_name.nil? }
    end

#### Using a string with :if and :unless

A string passed to the :if or :unless option will be evaluated in the context of the object being validated.

    class PersonValidator
        include Veto.validator
        
        validates :last_name, :presence => true, :unless => "first_name.nil?"
    end

#### Grouping Conditional Valdiations

To conditionally run a block of validations, use the `with_options` method.

    class PersonValidator
        include Veto.validator
        
        with_options :if => :person_is_admin? do
            validates :admin_secret_code. :presence => true
            validates :admin_level, :inclusion => [3,4,5]
        end
        
        def person_is_admin?
            ...
        end
    end
    
#### Combining Conditional Statements

You can use multiple `:if` and `:unless` statements together simultaniously in an array. The condition will pass only if all `:if` conditionals return true, and no `:unless` statements return true.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => true, 
                               :if => [:person_has_name?, Proc.new{|person| person.is_human?}], 
                               :unless => ["nameless?", :skip_name_validation?]
    end

#### Conditional Locations

Conditional statements can be assigned as an options hash to the `with_options` method, the `validates` method, or an an options hash for an individual validator in the `validates` method.

    class PersonValidator
        include Veto.validator
        
        with_options :if => :my_condition_1
            validates :first_name. :presence => true, :min_length => 3, :if => :my_condition_2
            validates :last_name, :presence => {:unless => :my_condition_3}, :min_length => 3
        end
    end

### Custom Validation

Veto allows you to create your own custom validation methods and validators as you require them.

#### Custom Methods

You can use a method to check the current state of the entity, and add custom error messages to the errors object if the entity is invalid. Register these methods using the `validate` method. Multiple validation methods can be assigned at once, as well as a hash of condition options included as the last method argument.

    class PersonValidator
        include Veto.validator
        
        validate :supervisor_must_have_supervisor_code, :admins_have_last_names
        
        def supervisor_must_have_supervisor_code
            if entity.is_admin? && entity.employees.size > 0 && supervisor_code.nil?
                errors.add(:supervisor_code, "can't be blank")
            end
        end
        
        def admins_have_last_names
            if entity.is_admin? && entity.last_name
                errors.add(:last_name, "can't be blank")
            end
        end
    end

Create a method inside your validator that checks the current state of the entity, and adds appropriate errors if it is invalid. Next, register this method using the `validates` method

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
