class_name DamageCalculations
extends Resource

func damagetaken(damage,armor,endurance) -> float:
	return damage/(((armor+(endurance**.6+1))/100)+1)

func damagedelt(endurance,armor,strength,precision,wepon_damage):
	var armour_weight_reduction:float = (((100-armor**(1/1.6))*((2/(endurance*.14+1))+1))/100)
	var Total_wepon_damage:float = (wepon_damage*(-(1/(precision*0.03+(1/6)))+6))
	var Strength_damage_multiplier:float = (((1+strength**(1/2))/13)+1)
	var damage:float = (armour_weight_reduction*Total_wepon_damage)*Strength_damage_multiplier
	return damage
