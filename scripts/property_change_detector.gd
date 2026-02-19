extends Node
class_name PropertyChangeDetector

var oldValue
var callback: Callable

func _init(callback_: Callable, val):
	callback = callback_
	oldValue = val

func update(property):
	if oldValue and oldValue != property:
		callback.call_deferred(oldValue, property)
	
	oldValue = property
