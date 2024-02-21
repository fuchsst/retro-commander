extends Resource
class_name PromotionDialogs

# Holds the dialogs played when player get reassigned and the medal ceremony

@export var colonel_office: Array[DialogProperties]
@export var medal_ceremony: Array[DialogProperties]

func _to_string() -> String:
	return "{ " + \
	"'colonel_office': " + str(colonel_office) + ", " +  \
	"'medal_ceremony': " + str(medal_ceremony) + \
	" }"
