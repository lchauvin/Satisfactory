function getProductionRate(constructor)
	duration_recipe = constructor:getRecipe().duration
	duration_min = 60 / duration_recipe
	cur_potential = constructor.currentPotential
	cur_boost = constructor.currentProductionBoost
	production_rate = duration_min * cur_potential * cur_boost
	return production_rate
end

concrete_counter_1 = component.proxy("91CDB77C469918E3A987ACA09C598A48")
concrete_prod_1 = concrete_counter_1:getCurrentIPM()

concrete_constrs = component.proxy(component.findComponent(classes.Build_ConstructorMk1_C))
print(#concrete_constrs)

total_production = 0
for _, c in pairs(concrete_constrs) do
	total_production = total_production + getProductionRate(c)
end

if concrete_prod_1 < total_production * 0.95 then
	print("Concrete Production is below 95%")
else
	print("Concrete Production is above 95% of theoretical limit (", math.floor(concrete_prod_1 * 100 / total_production), "%) !! Congratulation !!")
end
