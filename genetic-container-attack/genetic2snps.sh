#/bin/bash
genetic_index=(197329041 119762175 60997570 3251376 110218761)

if [ ! -d "./train-data-face" ]; then
        mkdir ./train-data-face
fi

for folder in ${genetic_index[@]}
do
	if [ ! -d "./train-data-face/$folder" ]; then
  		mkdir ./train-data-face/$folder
	fi
done

ls | grep vcf | while read file
do
	echo $file
	for index in ${genetic_index[@]};
	do
		results=$(cat $file | grep $index)
		genetic=$(echo $file | cut -d "-" -f1)
		if [ -n "$results" ]
		then
			cp ./pic-HGdata/*$genetic* train-data-face/$index/
		fi
	done
done
