#!/bin/bash
pckgs=(); info=()

# gets all packages which needs to be updated
while IFS= read -r line; do
	info+=("$line")

	pckg=$(echo "$line" | cut -d ' ' -f 1)
	pckgs+=( $pckg )

done <<< $(pip3 list --outdated | tail -n +3)

printf 'The following %d packages will be upgraded:\n' "${#pckgs[@]}"

for i in "${info[@]}"; do
	printf '%s\n' "$i"
done


# upgrades all the outdated packages
upgrade_packages () {
	printf '\n'
	for i in ${pckgs[@]}; do
		printf '> Upgrading %s:\n' "$i"
		pip install -U $i
	done

	printf '> Done!\n'
}

# TODO: implement function to check for dependency errors at the end of package upgrades

set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

while true; do
    read -p "Continue (${yesword} / ${noword})? " yn
    if [[ "$yn" =~ $yesexpr ]]; then upgrade_packages; exit; fi
    if [[ "$yn" =~ $noexpr ]]; then exit; fi
    echo "Answer ${yesword} / ${noword}."
done
