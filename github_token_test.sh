create_github_repository() {
	local username=`git config github.user`
	local token=`git config github.token`
	local repository=$1
	#echo $username $token $repository
	if [ -z "$username" ] || [ -z "$token" ] || [ -z "$1" ] ; then
		echo "miss github username , token or repository name!"
		return -1
	fi
	
	#echo "create github remote & local repository . "
	#git init 
	
	#echo '{"name":"'$repository'" }'
	#echo '{"name":"$repository"}'
	curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repository'" }'  > /dev/null 2>&1
	
	if [ $? -ne 0 ] ; then
		echo "create remote repository err!"
		return -1
	fi

	#echo push ?
}

delete_github_repository() {
	local username=`git config github.user`
	local token=`git config github.token`
	local repository=$1
	#echo $username $token $repository
	if [ -z "$username" ] || [ -z "$token" ] || [ -z "$1" ] ; then
		echo "miss github username , token or repository name!"
		return -1
	fi
	
	curl -X DELETE -u "$username:$token" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$username/$repository 
	
	if [ $? -ne 0 ] ; then
		echo "delete remote repository err!"
		return -1
	fi
}

attach_github_repository() {
	local username=`git config github.user`
	local repository=`basename $(pwd)`

	if [ ! -e  .git ] || [ -z "$username" ] ; then
		echo "not in git tree or not find git username?"
		return -1
	fi
	
	if  [  ! -z "$1" ] ; then
		repository=$1	
	fi


	#echo $repository
	create_github_repository $repository
	git remote add origin git@github.com:$username/$repository.git
	git push origin master
}


new_repository_local_and_github() {
	local username=`git config github.user`
	local repository=$1
	if [ -z "$username" ] || [  -z "$1" ] ; then
		echo "miss username or  repository name!"
		return -1
	fi
	
	echo "init local git repository!"
	create_github_repository $repository
	git clone git@github.com:$username/$repository.git $repository
	cd $repository
}
