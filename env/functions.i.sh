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

get_sensitive()
{
	key="$1"
	if [ -n "$key" ]
	then
		aws ssm get-parameters --region us-east-1 --names "$key" --with-decryption --query Parameters[0].Value --output text
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


completed_log_dir=/etc/nomrtears/.completed
mkdir -p $completed_log_dir
is_completed()
{
	component="$1"
	[ -e "$completed_log_dir/$component" ] && return 0 || return 1
}
mark_completed()
{
	component="$1"
	date >> "$completeded_log_dir/$component"
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
