# Called within a class definition, establishes a containment
# relationship with another class

Puppet::Parser::Functions::newfunction(
  :contain,
  :arity => -2,
  :doc => "Contain one or more classes inside the current class. If any of
these classes are undeclared, they will be declared as if called with the
`include` function. Accepts a class name, an array of class names, or a
comma-separated list of class names.

A contained class will not be applied before the containing class is
begun, and will be finished before the containing class is finished.
"
) do |classes|
  scope = self

  included = scope.function_include(classes)

  included.each do |resource|
    # Remove global anchor since it is not part of the resource title and what was just
    # included is then not found.
    #class_resource = scope.catalog.resource("Class", class_name.sub(/^::/, ''))
    if ! scope.catalog.edge?(scope.resource, resource)
      scope.catalog.add_edge(scope.resource, resource)
    end
  end
end
