param addressSapce string = '10.10.0.0/16'

var firstOutput = split(addressSapce, '.')

var mask1 = firstOutput[0]
var mask2 = firstOutput[1]

output sub1 string = '${mask1}.${mask2}.250.0/26'
output sub2 string = '${mask1}.${mask2}.1.0/24'
output sub3 string = '${mask1}.${mask2}.123.0/24'
output sub4 string = '${mask1}.${mask2}.250.0/26'
