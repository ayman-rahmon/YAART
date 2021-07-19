




# reading from a csv file and actually installing packages...
while IFS=, read -r field1 ,field2 , field3
do
	echo "$field1 and $field2"

done < packages.csv
