# source me


role_file=/etc/nomrtears/roles.txt

has_role()
{
	if grep -q "$1" $role_file 2>/dev/null
	then
		return 0
	else
		return 1
	fi
}


update_file()
{
	source="$rundir/files/$1"
	dest="$2"

	if [ "$source" -nt "$dest" ]
	then
		cp $source $dest
	fi
}


deploy_modules()
{
	for m in "$@"
	{
		if [ -d "$rundir/$m" ]
		then
			echo "Deploying module $m ..."
			for s in "$rundir/$m"/*.sh
			{
				bash "$s"
			}
		fi
	}
}
