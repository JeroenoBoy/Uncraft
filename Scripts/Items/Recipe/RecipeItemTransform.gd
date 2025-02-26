class_name RecipeItemTransform
extends Resource

enum TransformType {
	RemoveItem,
	AddItem,
	RemovePart
}

@export var transform_type: TransformType
@export var count = 1
@export var item_data: ItemData
@export var item_part: ComplexItemPart

func process(inventory: Inventory):
	match transform_type:
		TransformType.RemovePart:
			for i in range(count):
				var item = inventory.get_item(item_data, [item_part])
				item.remove_part(item_part)

		TransformType.RemoveItem:
			for i in range(count):
				inventory.remove_item(item_data).queue_free()
				
		TransformType.AddItem:
			for i in range(count):
				inventory.add_item_skip_checks(Item.create(item_data))

		_:
			push_error("Unkown transform type " + str(transform_type))
		
