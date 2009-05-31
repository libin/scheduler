require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper'

describe <%= controller_class_name %>Helper do # Helper methods can be evented directly in the examples (it blocks)
end
