# Veto

Veto provides lightweight validation for plain old ruby objects, using a familiar DSL.

Tested on the following Rubies: MRI 2.0.0.

## Installation

Add this line to your application's Gemfile:

    gem 'veto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install veto

## Usage

    # Create a validator
    class PersonValidator
        include Veto.validator
        
        validate :name, :presence => true
        validate :age, :inclusion => 0..100
    end
    
    # Create an entity
    class Person
        attr_reader :name, :age, :errors
    end
    
    person = Person.new
    
    # Validation using class methods
    
    PersonValidator.valid?(person) # => false
    PersonValidator.validate!(person) # => # => Veto::InvalidEntity, ["name is not present", "..."]  

    # Validation using validator instance
    
    validator = PersonValidator.new(person)
    validator.valid? # => false
    validator.validate! # => # => Veto::InvalidEntity, ["name is not present", "..."]  
    validator.errors.full_messages # => ["first name is not present", "..."]

    # If entity has errors attr_accessor, errors will be passed to the entity
    
    person.errors # => nil
    PersonValidator.valid?(person) # => false
    person.errors.full_messages # => ["first name is not present", "..."]

### Class Method Usage

The simplest way to validate an entity is to pass it directly to one of the validator's class methods.

#### valid?

Validate an entity by passing it to the `valid?` method.

    person = Person.new
    PersonValidator.valid?(person) # => false
         
#### validate!

For strict validations, pass the entity to the `validate!` method instead. This method will raise an exception if the validation fails.
    
    person = Person.new
    PersonValidator.validate!(person) # => Veto::InvalidEntity, ["first name is not present", "..."]    
    
### Instance Method Usage
        
Using a validator instance is also simple, and has some advantages in regards to validation errors (more below). The validation methods available on a validator instance are the same as the class methods.    

#### initialization

When creating a validator instance, the entity you wish to be validated needs to be passed as an argument to the `new` method.

    person = Person.new
    validator = PersonValidator.new(person)
    
#### valid?

Calling the `valid?` method on a validator instance will return a boolean response, although the method does not receive  arguments.

    person = Person.new
    validator = PersonValidator.new(person)
    validator.valid? # => false
   
#### validate!

For strict validations…
    
    person = Person.new
    validator = PersonValidator.new(person)
    validator.validate! # => Veto::InvalidEntity, ["first name is not present", "..."]

#### errors

The `errors` method will return an errors object. The errors object will contain the error messages generated during the most recent validation.


    person = Person.new
    validator = PersonValidator.new(person)
    validator.errors.full_messages # => []
    
    validator.valid? # => false
    validator.errors.full_messages # => ["first name is not present", "..."]

### Errors on Entity

Whether you're validating via validator class methods or a validator instance, if the entity being validated has an `errors` attr_accessor defined, the validator will attempt to populate the entity with an errors object each time it is validated.

    class Person
        attr_accessor :errors, :first_name, :last_name, ...
    end

    person = Person.new
    person.errors # => nil
    
    PersonValidator.valid?(person) # => false
    person.errors.full_messages # => ["first name is not present", "..."]

## Validation Helpers

### Presence
Likely the most used validation helper, the `presence` helper will check that the specified object attribute is not blank. Object attributes that are nil, or respond to `empty?` and return true, are considered blank. All other values will be considered present. This means that `presence` helper is safe to use for boolean attributes, where you need to ensure that the attribute value can be true or false, but not nil.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => true
    end

### Not Null
Similar to the `presence` helper, the `not_null` helper will strictly check that the specified attribute is not null/nil. Any attribute where `nil?` returns true is considered null. Other values, including blank strings and empty arrays, are all considered not-null and will pass.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :not_null => true
    end
    
### Format
The `format` helper ensures that the string value of an attribute matches the specified regular expression. It's useful for ensuring that email addresses, URLs, UPC codes, ISBN codes, and the like, are in a specific format. It can also be used to check that only certain characters are used in the string.

    class PersonValidator
        include Veto.validator
  
        validates :email, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
        
            # OR
        
        validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  
    end
    
### Inclusion
This helper ensures that an attribute is included in a specified set, or range of values.

    class PersonValidator
        include Veto.validator
        
        validates :role, :inclusion => [:webmaster, :admin, :user]
        
            # OR
        
        validates :role, :inclusion => { :in => [:webmaster, :admin, :user] }
    end
    
### Integer
This helper checks that the specified attribute can be a valid integer. For example, the values `123` and `'123'` will both pass, but `123.4` and `'123.4'` will both fail.

    class PersonValidator
        include Veto.validator
        
        validates :age, :integer => true    
    end

### Numeric
This helper checks that the specified attribute can be a valid float. For example, the values `123.4` and `'123.4'` will both pass.

    class PersonValidator
        include Veto.validator
        
        validates :height, :numeric => true    
    end

### Exact Length
This helper checks that an attribute is an exact length in characters.

    class BookValidator
        include Veto.validator
        
        validates :isbn, :exact_length => 17
        
            # OR
            
        validates :isbn, :exact_length => { :with => 17 }
    end

### Max Length
This helper checks that an attribute does not exceed a given maximum character length.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :max_length => 10
        
            # OR
            
        validates :first_name, :max_length => { :with => 10 }
    end

### Min Length
This helper checks that an attribute is longer than a given minimum character length.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :min_length => 3
        
            # OR
            
        validates :first_name, :min_length => { :with => 3 }
    end

### Length Range
This helper checks that the length of an attribute falls within a given range, or other object that responds to `include?`

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :length_range => 3..10
        
            # OR
            
        validates :first_name, :length_range => { :in => 3..10 } 
    end

## Common Validation Options
### message

The `:message` option allows you to specify the error message that will be added to the errors object when validation fails.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => {:message => "has not been set"}
    end
    
### on

The `:on` options allows you to specify which attribute name a given validation error should be applied to.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => {:on => :last_name}
    end
    
    person = Person.new
    PersonValidator.validate!(person) # => Veto::InvalidEntity, ["last_name is not present""]   

## Conditional Validation

You may want a validation to run only when a specified condition is satisfied. To accomplish this, you can pass `:if` and `:unless` options to the validators. Passing an `:if` condition to a validator will ensure that the validation is **only** run if the condition returns true. Passing an `:unless` condition to a validator will ensure that the validation is **always** run unless the condition returns true.

### Using a symbol with :if and :unless

Passing a symbol to the :if or :unless option will call the corresponding validator method upon validation.

    class PersonValidator
        include Veto.validator
        
        validates :last_name, :presence => true, :if => :first_name_set?
        
        def first_name_set?
            entity.first_name
        end
    end
    
### Using a proc with :if and :unless

A Proc object passed to an :if or :unless condition will be run during validation. The Proc object will receive the entity being validated as an argument.

    class PersonValidator
        include Veto.validator
        
        validates :last_name, :presence => true, :unless => Proc.new{|person| person.first_name.nil? }
    end

### Using a string with :if and :unless

A string passed to the :if or :unless option will be evaluated in the context of the entity being validated.

    class PersonValidator
        include Veto.validator
        
        validates :last_name, :presence => true, :unless => "first_name.nil?"
    end

### Grouping Conditional Validations

To conditionally run a block of validations, nest them inside a `with_options` method.

    class PersonValidator
        include Veto.validator
        
        with_options :if => :person_is_admin? do
            validates :admin_secret_code. :presence => true
            validates :admin_level, :inclusion => [3,4,5]
        end
        
        def person_is_admin?
            entity.is_admin
        end
    end
    
### Combining Conditional Statements

You can use multiple `:if` and `:unless` statements together simultaneously in an array. The condition will pass only if all `:if` conditionals return true, and no `:unless` statements return true.

    class PersonValidator
        include Veto.validator
        
        validates :first_name, :presence => true, 
                               :if => [:person_has_name?, Proc.new{|person| person.is_human?}], 
                               :unless => ["nameless?", :skip_name_validation?]
    end

### Conditional Locations

Conditional statements can be assigned as an options hash to the `with_options` method, the `validates` method, or an an options hash for an individual validator in the `validates` method.

    class PersonValidator
        include Veto.validator
        
        with_options :if => :my_condition_1
            validates :first_name. :presence => true, :min_length => 3, :if => :my_condition_2
            validates :last_name, :presence => {:unless => :my_condition_3}, :min_length => 3
        end
    end

## Custom Validation

Veto provides a few ways to create your own validators and validation methods, when your needs are too complex for the built-in validation syntax.

### Custom Methods

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

### Custom Attribute Validator

Much like the built-in `presence`, `max_length`, and `format` attribute validators, you can create your own custom validator, and refer to it using the `validates` method. Custom attribute validators must extend the Veto::AttributeValidator class, implement a `validate` method which receives 5 arguments: entity, attribute, value, errors, and options.

    class PersonValidator
        include Veto.validator
        
        class EmailValidator < ::Veto::AttributeValidator
            def validate(entity, attribute, value, errors, options={})
                unless value.to_s =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
                    errors.add(attribute, "is not a valid email address")
                end
            end
        end
        
        validates :electronic_address, :email => true
    end
    
## Configuration

Call the Veto `configure` method to yield the configuration object.

    Veto.configure do |c|
        ...
    end
   
### Messages

The `message` configuration object, allows you to change the default error message produced by each attribute validator. The message must be in the form of a lambda or Proc, and may or may not receive an argument. Use the example below for reference when customizing messages.

    Veto.configure do |c|
        c.message.set(:exact_length, lambda{|exact| "is not #{exact} characters"})
        c.message.set(:format, lambda{"is not valid"})
        c.message.set(:inclusion, lambda{|set| "is not in set: #{set.inspect}"})
        c.message.set(:integer, lambda{"is not a number"})
        c.message.set(:length_range, lambda{"is too short or too long"})
        c.message.set(:max_length, lambda{|max| "is longer than #{max} characters"})
        c.message.set(:min_length, lambda{|min| "is shorter than #{min} characters"})
        c.message.set(:not_null, lambda{"is not present"})
        c.message.set(:numeric, lambda{"is not a number"})
        c.message.set(:presence, lambda{"is not present"})
    end


If you would like to change the default message produced by a specified validator, you can do so using through the configuration object.

Create a new validator by including the Veto validator module in your class.

    class PersonValidator
        include Veto.validator
    end
    
    
## Working With Errors

Veto's simple errors object is a subclass of hash, with a few additional methods for inspecting the collection of error messages.
    
#### errors.add
Adds a method to the errors object.

    errors.add(:first_name, "is not present")
    
#### errors.empty?
Returns a boolean value representing if the errors object is empty or not.

    errors.empty? # => true
    errors.add(:first_name, "is not present")
    errors.empty? # => false

#### errors.count
Returns the number of errors present in the errors object.

    errors.count # => 0
    errors.add(:first_name, "is not present")
    errors.count # => 1

#### errors.on
Returns a list of error message for a given attribute.

    errors.on(:first_name) # => nil
    errors.add(:first_name, "is not present")
    errors.add(:first_name, "is too short")
    errors.on(:first_name) # => ["is not present", "is too short"]

#### errors.full_messages
Returns a list of full error messages.

    errors.add(:first_name, "is not present")
    errors.add(:last_name, "is too short")
    errors.full_messages # => ["first_name is not present", "last_name is too short"]


## Veto Model

If your entities and validators have a strict 1-to-1 relationship (an entity will only ever be validated by a single validator, and a validator will only ever validate a single entity), it might make sense to embed the validator directly inside the entity.

The Veto Model extension does exactly this, associating your entity with a specified validator, and adding 3 additional methods to your entity: `valid?`, `validate!`, and `errors`

    class Person
        include Veto.model(PersonValidator)
    end
    
    person.new
    person.valid? # => false
    person.errors.full_messages # => ["first name is not present", "last name is not present"]
    person.validate! # => Veto::InvalidEntity, ["first name is not present", "..."]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request