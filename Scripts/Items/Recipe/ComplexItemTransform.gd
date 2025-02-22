class_name ComplexItemTransform
extends BaseItemTransform

@export var action: ItemTransformComplexAction
@export var item: ComplexItem
@export var part: ComplexItemPart

enum ItemTransformComplexAction {
	Add,
	Remove
}
