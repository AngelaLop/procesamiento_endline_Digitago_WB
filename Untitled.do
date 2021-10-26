
/*==================================================
              Tablas de balance
==================================================*/


******** Balance table ************************************
******* Module H4 - HARVEST *******************************
 * unconditional 
global harvest yield_2_1 yield_2_6 yield_2_9 yield_2_13 yield_2_15 yield_2_16 yield_2_20 yield_2_21 yield_2_31 yield_2_34 yield_2_35 yield_2_37 yield_2_40 yield_2_42 yield_2_43 yield_2_44 yield_2_45 yield_2_46 yield_2_47 yield_2_48 yield_2_49 yield_2_50 yield_2_997 yield_2_998 yield_2_999 yield_2_1000 yield_3_1 yield_3_2 yield_3_3 yield_3_4 yield_3_5 yield_3_999 yield_4_51 yield_4_52 yield_4_53 yield_4_54 yield_4_55 yield_4_56 yield_4_57 yield_4_58 yield_4_59 yield_4_60 yield_4_61 yield_4_62 yield_4_63 yield_4_64 yield_4_994 yield_4_995 yield_4_996 yield_4_1000 
 
iebaltab $harvest, pt grpvar(niveles_dis) save("$out\1.individial_ch_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) control(2) ///
rowlabels( ///
yield_2_1 	"In June and July 2021, what did the household harvest?   1. Chard" @ ///
yield_2_6	"    6. Broccoli" @ ///
yield_2_9	"    9. Onion" @ ///
yield_2_13	"   13. Cilantro" @ ///
yield_2_15	"   15. Spinach" @ ///
yield_2_16	"   16. Black bean" @ /// 
yield_2_20	"   20. Limes" @ ///
yield_2_21	"   21. Corn" @ ///
yield_2_31	"   31. Potato" @ ///
yield_2_34	"   34. Plantain" @ ///
yield_2_35	"   35. Cabbage" @ ///
yield_2_37	"   37. Tomato" @ ///
yield_2_40	"   40. Carrots" @ ///
yield_2_42	"   42. Radish" @ ///
yield_2_43	"   43. Cucumber" @ ///
yield_2_44	"   44. Fava bean" @ ///
yield_2_45	"   45. Cauliflower" @ ///
yield_2_46	"   46. Chipilín" @ ///
yield_2_47	"   47. Coffee" @ ///
yield_2_48	"   48. Banana" @ ///
yield_2_49	"   49. Beetroot" @ ///
yield_2_50	"   50. Lettuce" @ ///
yield_2_997	"   997. Other1" @ ///
yield_2_998	"   998. Other2" @ ///
yield_2_999	"   999. Other3" @ ///
yield_2_1000 "1000. None" @ ///
yield_3_1	"In June and July 2021, why didn't the household partake in a harvest?    1. It's not the season " @ ///
yield_3_2	"    2. Lack of manpower" @ ///
yield_3_3	"    3. There is no where to sell" @ ///
yield_3_4	"    4. Dedicated to other work" @ ///
yield_3_5	"    5. Low prices" @ ///
yield_3_999	"  999. Other (Specify)" @ ///
yield_4_51	" In the months of June and July 2021, did you make or harvest any products from the animals that the household raised? (eg milk, eggs, cheese, meat, etc.)   51. Cow Milk" @ ///
yield_4_52	"   52. Milk from other animals " @ ///
yield_4_53	"   53. cow cheese" @ ///
yield_4_54	"   54. Cheese from other animals" @ ///
yield_4_55	"   55. Sausages" @ ///
yield_4_56	"   56. Chicken eggs" @ ///
yield_4_57	"   57. Bee honey" @ ///
yield_4_58	"   58. Butter" @ ///
yield_4_59	"   59. Lard" @ ///
yield_4_60	"   60. Wool" @ ///
yield_4_61	"   61. Cooking cream" @ ///
yield_4_62	"   62. Beef" @ ///
yield_4_63	"   63. Chicken meat" @ ///
yield_4_64	"   64. Meat from other animals" @ ///
yield_4_994	"   994. Other1" @ ///
yield_4_995	"   995. Other2" @ ///
yield_4_996	"   996. Other3" @ ///
yield_4_1000 "1000. None" @ ///
) replace
 
 
* Efectos fijos por pais



 
 
 