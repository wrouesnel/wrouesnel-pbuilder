# Set a version number for a build from mercurial
user_hgdch() {
    if [ ! -e debian/changelog ]; then
        echo "debian/changelog not found!"
        return
    fi

    # Get epoch and upstream version
    DEBVERSION=$(dpkg-parsechangelog | sed -n "s/^Version: //p" | \
        grep -Po '(\d+)?:?(\d+)\.(\d+)\.(\d+)')

	# Date we built the source package
    BUILDDATE=$(date +%s)
    # Commitish
    CHANGESET=$(hg identify | cut -d' ' -f1 | sed 's/\+/dirty/')

	# We only do this when we want to supercede versions, but no one conforms
	# to useful patterns in Mint development it seems. So instead, grab the
	# candidate version on the current system and beat that by appending to it,
	# but only if the debversion on its own wouldn't.
	SOURCEPACKAGENAME=$(dpkg-parsechangelog | sed -n "s/^Source: //p")
	CANDIDATEVERSION=$(apt-cache showsrc $SOURCEPACKAGENAME | grep -m 1 Version: | \
		 	sed -n 's/Version: //p')
    
    # Check if the raw deb version would supercede the installed version
	if dpkg --compare-versions $DEBVERSION gt $CANDIDATEVERSION; then
		echo "$DEBVERSION supercedes installed version. Using a nicely formed version number."
		BUILDDEBVERSION=$DEBVERSION
	else
		if [ -z $CANDIDATEVERSION ]; then
			echo "No candidate version found. Using package version."
			BUILDDEBVERSION=$DEBVERSION
		else
			echo "$DEBVERSION does not supercede installed version. Using an appended version number."
			BUILDDEBVERSION=$CANDIDATEVERSION		
		fi
	fi

	# Now create a useful version number increment.
	FULLVERSION="$BUILDDEBVERSION+${USER}$BUILDDATE~hg$CHANGESET"
    echo "Setting package version to: $FULLVERSION"

    dch -v $FULLVERSION "Hg build from commit $CHANGESET"
}

# Set a version number for a build from git
user_gitdch() {
    if [ ! -e debian/changelog ]; then
        echo "debian/changelog not found!"
        return
    fi

    # Get epoch and upstream version
    DEBVERSION=$(dpkg-parsechangelog | sed -n "s/^Version: //p" | \
        grep -Po '(\d+)?:?(\d+)\.(\d+)\.(\d+)')

	# Date we built the source package
    BUILDDATE=$(date +%s)
    # Commitish
    GITTISH=$(git rev-parse --short HEAD)

	# We only do this when we want to supercede versions, but no one conforms
	# to useful patterns in Mint development it seems. So instead, grab the
	# candidate version on the current system and beat that by appending to it,
	# but only if the debversion on its own wouldn't.
	SOURCEPACKAGENAME=$(dpkg-parsechangelog | sed -n "s/^Source: //p")
	CANDIDATEVERSION=$(apt-cache showsrc $SOURCEPACKAGENAME | grep -m 1 Version: | \
		 	sed -n 's/Version: //p')
    
    # Check if the raw deb version would supercede the installed version
	if dpkg --compare-versions $DEBVERSION gt $CANDIDATEVERSION; then
		echo "$DEBVERSION supercedes installed version. Using a nicely formed version number."
		BUILDDEBVERSION=$DEBVERSION
	else
		if [ -z $CANDIDATEVERSION ]; then
			echo "No candidate version found. Using package version."
			BUILDDEBVERSION=$DEBVERSION
		else
			echo "$DEBVERSION does not supercede installed version. Using an appended version number."
			BUILDDEBVERSION=$CANDIDATEVERSION		
		fi
	fi

	# Now create a useful version number increment.
	FULLVERSION="$BUILDDEBVERSION+${USER}$BUILDDATE~git$GITTISH"
    echo "Setting package version to: $FULLVERSION"

    dch -v $FULLVERSION "Git build from commit $(git rev-parse HEAD)"
}