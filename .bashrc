if command -v tmux>/dev/null; then
	if [ ! -z "$PS1" ]; then 
		[[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
	fi
fi
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
export PATH=$PATH:~/.local/bin
#export PATH="${PATH}:~/.local/bin"
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:${GOPATH//://bin:}/bin
export PATH=$PATH:/usr/bin/edirect
export PATH=$PATH:/usr/bin/formd
export PATH=$PATH:/usr/local/bin/drive-linux-amd64
export PATH=$PATH:/home/louis/opt/FFcast/usr/bin
export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[0;32m\] 🚶\[\033[01;34m\] \w \$\[\033[00m\] "
export PS2="\[\033[0;32m\] 🚵\[\033[00m\] "
#export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]"
#alias bib='/home/louis/.local/bin/bib'
source /home/louis/root/bin/thisroot.sh
export PATH=$ROOTSYS/bin:$PATH
export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
export scholaRdaemon="/home/louis/Dropbox/Y3/Programming/scholaRdaemon/"
alias runsd='Rscript "$scholaRdaemon/run_daemon"'
alias runsdaemon-debug='Rscript "$scholaRdaemon/run_daemon" --debug'
eval "$(hub alias -s)"
alias ls='ls --color=auto'
alias less='less -R'
alias recent='ls -ht | head'
alias recentsizes='du -h $(recent)'
alias wget='wget -c'
alias c='clear'
function b() {
	str=""
	count=0
	while [ "$count" -lt "$1" ];
	do
		str=$str"../"
		let count=count+1
	done
	cd $str
}
alias vbashrc='vim /home/louis/.bashrc'
alias bbbash='source /home/louis/.bashrc'
alias nameserverconf="sudo vim /etc/resolv.conf"
alias toscholaRdaemon='cd "$scholaRdaemon"'
alias gstat="git status"
alias gadd="git add ."
alias got="git push origin master"
function gcmmt { git commit -m "$@"; }
alias togit="cd /gits"
alias togitdrafts="cd /gits/draftposts"
alias todb="cd ~/Dropbox"
alias todbc="cd ~/Dropbox/louis_chimera"
alias todbcc="cd ~/Dropbox/louis_chimera/cytoscape/cytoscape"
alias torev="cd ~/Dropbox/Y3/Project/Review/"
alias torevlit="cd ~/Dropbox/Y3/Project/Review/Literature/"
alias torevman="cd ~/Dropbox/Y3/Project/Review/Manuscript/"
alias toprojwork="cd ~/Dropbox/Y3/Project/S6/"
alias toblogimages="cd /gits/shots/"
function take-shot 	(){
	# Allow take-shot without versioning: create array if one doesn't exist
	if [ -z ${shots+x} ]; then shots=(); fi
	# would leave array lying around so needs wrapper to clean up: make-shots
	shootyear="$(date | awk '{print $6}')";
	shootmonth="$(date | awk '{print $2}')";
	mkdir -p "/gits/shots/$shootyear/$shootmonth";
	shotfile="$(echo "$@")";
	cp "$shotfile" "/gits/shots/$shootyear/$shootmonth";
	shotfilename=$(basename "$shotfile");
	encodedshot="$(python -c 'from urllib import quote; print quote("'"$shotfilename"'").encode("utf-8")')"
	shots+=("https://raw.githubusercontent.com/lmmx/shots/master/$shootyear/$shootmonth/$encodedshot");
}
function make-shots	(){ for shot in "$@"; do take-shot $shot; done; shots=""; }
function take-shots	(){ for shot in "$@"; do take-shot $shot; done; }
function shoot          (){
	shots=();
	take-shots "$@";
        cd /gits/shots/;
	git add .;
        git commit -m "Added $@";
	git push origin master;
	cd - > /dev/null;
	printf '%s\n' "${shots[@]}";
}
function gnews		  {
	gitnews="$(git status --porcelain)";
	export gitnews;
	gitreport="$(python -c 'from os import environ as e; gnew=e["gitnews"].split("\n");\
	mods=[stat[3:] for stat in gnew if stat[0]=="M"];\
	adds=[stat[3:] for stat in gnew if stat[0]=="A"];\
	dels=[stat[3:] for stat in gnew if stat[0]=="D"];\
	rens=[stat[3:] for stat in gnew if stat[0]=="R"];\
	cops=[stat[3:] for stat in gnew if stat[0]=="C"];\
	upds=[stat[3:] for stat in gnew if stat[0]=="U"];\
	modreport=["Changed ".join(["",", ".join(statuslist)]) for statuslist in [mods] if len(mods)>0];\
	addreport=["Added ".join(["",", ".join(statuslist)]) for statuslist in [adds] if len(adds)>0];\
	delreport=["Deleted ".join(["",", ".join(statuslist)]) for statuslist in [dels] if len(dels)>0];\
	renreport=["Renamed ".join(["",", ".join(statuslist)]) for statuslist in [rens] if len(rens)>0];\
	copreport=["Copied ".join(["",", ".join(statuslist)]) for statuslist in [cops] if len(cops)>0];\
	updreport=["Updated ".join(["",", ".join(statuslist)]) for statuslist in [upds] if len(upds)>0];\
	report=[". ".join(stats) for stats in [modreport,addreport,delreport,renreport,copreport,updreport] if len(stats)>0];\
	print ". ".join(report)')";
	unset gitnews;
	echo "$gitreport";
}
function getgot		  {
	git add .;
	commitment="$(gnews)";
	git commit -m "$commitment";
	git push origin master;
}
function findapdf	(){
	pdfhold="held"
	pdfsearchlist=$(find / -path /usr/share -prune -o -iname "$@"*.pdf 2>/dev/null | sed '/\/usr\/share/d')
	# echo "$pdfsearchlist" | awk '{printf("%5d %s\n", NR,$0)}' | sed 's/^ *//'
	if [[ "$@" != '' ]]; then
		if [[ $(echo "$pdfsearchlist" | wc -l) == 1 ]]; then
			evince "$pdfsearchlist"
		else
			pdflistcount=0
			prepdfbase_IFS=$IFS
			IFS=$'\n'
			for pdfbaseline in $(echo "$pdfsearchlist"); do
				(( pdflistcount++ ))
				echo -e $pdflistcount"\t"$(basename "$pdfbaseline")
			done
			IFS=$prepdfbase_IFS
			printf "Please choose a file: "
			read pdfnum
			if [[ $pdfnum -gt 0 ]] && [[ $pdfnum -le $pdflistcount ]]; then
				selectedpdf=$(echo "$pdfsearchlist" | sed $pdfnum'q;d')
				evince "$selectedpdf"
			else
				echo "Please enter a number between 1 and "$pdflistcount"."
			fi
		fi
	fi
	pdfhold="released"
}
function awkcols { awk -F "\t" '{print NF}' "$@"; }
function expandt { expand -t 20,40,160 "$@"; }
function mmrlit { cat ~/Dropbox/Y3/MMR/Essay/literature_table.tsv; }
function mmrlitedit { vim ~/Dropbox/Y3/MMR/Essay/literature_table.tsv; }
function mmrlitgrep	(){ grep -i "$@" ~/Dropbox/Y3/MMR/Essay/literature_table_with_DOIs.tsv; }
function mmrlitdoi	(){ mmrlitgrep "$@" | cut -d $'\t' -f 4 | tr -d '\n' | xclip -sel p; clipconfirm;  }
function mmrlitdoicite	(){ mmrlitgrep "$@" | cut -d $'\t' -f 4 | awk '{print "`r citet(\""$0"\")`"}' | tr -d '\n' | xclip -sel p; clipconfirm; }
function litgrep     (){ grep -i "$@" ~/Dropbox/Y3/Project/Review/Manuscript/literature_ratings.tsv; }
function preslitgrep     (){ grep -i "$@" ~/Dropbox/Y3/Post-Genome\ Bio/Discussion\ presentations/Presentation\ work/literature_table.tsv; }
function preslitname	() { preslitgrep "$@" | cutf 1-3 | awk '{split($0,a,"\t"); print a[1]" ("a[2]") "a[3]".pdf"}'; }
function preslitcp () { preslitname "$@" | xclip -sel p; clipconfirm; }
function litdoicite	(){ litgrep "$@" | cut -d $'\t' -f 4 | awk '{print "`r citet(\""$0"\")`"}' | tr -d '\n' | xclip -sel p; clipconfirm; }
function litadd	(){ echo $(xclip -o) | awk '{split($0,a,"[()]"); printf a[1]"\t"a[2]"\t"a[3]"\t\t\n"}' >> ~/Dropbox/Y3/Project/Review/Manuscript/literature_ratings.tsv; litedit; }
function litedit	  { vim ~/Dropbox/Y3/Project/Review/Manuscript/literature_ratings.tsv; }
function titlecopy	(){ ls "$@" | awk '{split($0,a,".pdf"); print a[1]}' | xclip -sel p; clipconfirm; }
function littitlecopy	(){ ls ~/Dropbox/Y3/Project/Review/Literature/"$@"* | awk '{split($0,a,"/Literature/|.pdf"); printf a[2]}' | xclip -sel p; clipconfirm; }
function cutf		(){ cut -d $'\t' -f "$@"; }
function cuts		(){ cut -d ' ' -f "$@"; }
function findafile	(){ find / -iname "$@" 2>/dev/null; }
function findit		(){ find ./ -iname "$@" 2>/dev/null; }
function striptoalpha	(){ for thisword in $(echo "$@" | tr -dc "[A-Z][a-z]\n" | tr [A-Z] [a-z]); do echo $thisword; done; }
function pubmed		(){ esearch -db pubmed -query "$@" | efetch -format docsum | xtract -pattern DocumentSummary -present Author -and Title -element Id -first "Author/Name" -element Title; }
function pubmeddocsum	(){ esearch -db pubmed -query "$@" | efetch -format docsum; } 
function pubmedextractdoi (){ pubmeddocsum "$@" | xtract -pattern DocumentSummary -element Id -first "Author/Name" -element Title SortPubDate -block ArticleId -match "IdType:doi" -element Value | awk '{split($0,a,"\t"); split(a[4],b,"/"); print a[1]"\t"a[2]"\t"a[3]"\t"a[5]"\t"b[1]}'; }
function pubmeddoi	(){ pubmedextractdoi "$@" | cutf 4; }
function getdoispaced	(){
	if [[ $(echo "$@" | cuts 2) =~ [0-2][0-9]{3} ]]; then
		tabseppub=$(echo -e "$(echo $@ | cuts 1-2 | tr ' ' '\t')\t$(echo $@ | cuts 3-)")
		AddPubDOI "$tabseppub" | cutf 4
	fi
}
function pubmeddoiclip	(){ pubmeddoimulti "$@" | xclip -sel p; clipconfirm; }
function pubmeddoimulti (){ 
	xtracted=$(pubmedextractdoi "$@")
	if [[ $(echo "$xtracted" | cutf 4) == '' ]]
	then
		if [[ $xtracted == '' ]]
		then
			failcurl=$(curl -s "http://www.ncbi.nlm.nih.gov/pubmed?cmd=search&term="$(echo "$thistitle $thisauthor $thisyear" | tr ' ' '+'))
			curledpmid=$(echo "$failcurl" | grep 'sid="1" type="checkbox" id="UidCheckBox' | sed -n -e 's/^.*sid="1" type="checkbox" id="UidCheckBox//p' | awk -F\" '{print $1}')
			if [[ $curledpmid == '' ]]
			then
				echo "DOI NA: PMID NA"
			else	
				curleddoi=$(pmid2doimulti $curledpmid)
				if [[ $curleddoi == '' ]]
				then
					echo "DOI NA: PMID "$curledpmid
				else
					echo $curleddoi
				fi
        		fi
		else
			xtractedpmid=$(echo "$xtracted" | cutf 1)
			pmid2doirestful "$xtractedpmid"
		fi
	else
		echo "$xtracted" | cutf 4
	fi
}

function pubmeddoicite  (){ pubmeddoi "$@" | tr -d '\n' | xclip -sel p; clipconfirm; }
function pubmedrel 	(){ esearch -db pubmed -query "$@" | elink -related | efilter -query "NOT historical article [FILT]" | efetch -format docsum | xtract -pattern DocumentSummary -present Author -and Title -element Id -first "Author/Name" -element Title; }
function pmid2doi	(){ curl -s www.pmid2doi.org/rest/json/doi/"$@" | awk '{split($0,a,",\"doi\":\"|\"}"); print a[2]}'; }
function pmid2doimulti 	(){
	curleddoi=$(pmid2doi "$@")
	if [[ $curleddoi == '' ]]
	then
		pmid2doincbi "$@"
	else
		echo "$curleddoi"
	fi
}
function pmid2doincbi 	(){
	xtracteddoi=$(pubmedextractdoi "$@")
	if [[ $xtracteddoi == '' ]]
	then
		echo "DOI NA (pmid2doincbi): $@"
	else
		echo "$xtracteddoi"
	fi
}
function unknownDOIs	(){ grep 'DOI NA' "$@"; }
function DOIopen () {
	preopen_IFS=$IFS
	IFS=$'\n'
	for line in $(cat "$@"); do
		doisect=$(echo "$line" | cutf 4)
		if ! [[ $doisect =~ 'DOI NA' || $doisect == 'DOI' ]]; then
			google-chrome "http://dx.doi.org/"$doisect
			read dummyvar
		fi
	done
	IFS=$preopen_IFS
}
function AddPubTableDOIs   () {
	old_IFS=$IFS
	IFS=$'\n'
	for line in $(cat "$@"); do
		DOIresp=$(AddPubDOI "$line" 2>/dev/null)
		if [[ $DOIresp =~ 'DOI NA' ]]; then
			# try again in case it's just NCBI rate throttling, but just the once
			DOIresp2=$(AddPubDOI "$line" 2>/dev/null)
			if [[ $(echo "$DOIresp2" | awk 'BEGIN{FS="\t"};{print NF}' | uniq | wc -l) == '1' ]]; then
				echo "$DOIresp2"
				>&2 echo "$DOIresp"
			else
				DOIinput=$(echo "$line" | cutf 1-3)
				echo -e "$DOIinput\tDOI NA: Parse error"
				>&2 echo "$DOIinput\tDOI NA: Parse error"
			fi
		else
			if [[ $(echo "$DOIresp" | awk 'BEGIN{FS="\t"};{print NF}' | uniq | wc -l) == '1' ]]; then
				echo "$DOIresp"
				>&2 echo "$DOIresp"
			else
				DOIinput=$(echo "$line" | cutf 1-3)
				echo -e "$DOIinput\tDOI NA: Parse error"
				>&2 echo "$DOIinput\tDOI NA: Parse error"
			fi
		fi
	done
	IFS=$old_IFS
}

function AddPubDOI	(){
	if [[ $(echo "$@" | cutf 4) != '' ]]; then
		echo "$@"
		continue
	fi
	printf "$(echo "$@" | cutf 1-3)\t"
	thistitle=$(echo "$@" | cutf 3)
	if [[ $thistitle != 'Title' ]]; then
		thisauthor=$(echo "$@" | cutf 1)
		thisyear=$(echo "$@" | cutf 2)
		round1=$(pubmeddoimulti "$thistitle AND $thisauthor [AUTHOR]")
		round1hits=$(echo "$round1" | wc -l)
		if [[ "$round1hits" -gt '1' ]]; then
			round2=$(pubmeddoimulti "$thistitle AND $thisauthor [AUTHOR] AND ("$thisyear"[Date - Publication] : "$thisyear"[Date - Publication])")
			round2hits=$(echo "$round2" | wc -l)
			if [[ "$round2hits" -gt '1' ]]; then
				round3=$(
					xtracted=$(pubmedextractdoi "$@")
					xtractedtitles=$(echo "$xtracted" | cutf 3 | tr -dc "[A-Z][a-z]\n")
					alphatitles=$(striptoalpha "$xtractedtitles")
					thistitlealpha=$(striptoalpha "$thistitle")
					presearchIFS=$IFS
					IFS=$'\n'
					titlecounter="1"
					for searchtitle in $(echo "$alphatitles"); do
						(( titlecounter++ ))
						if [[ "$searchtitle" == *"$thistitlealpha"* ]]; then
							echo "$xtracted" | sed $titlecounter'q;d' | cutf 4
						fi
					done
					IFS=$presearchIFS
				)
				round3hits=$(echo "$round3" | wc -l)
				if [[ "$round3hits" -gt '1' ]]; then
					echo "ERROR multiple DOIs after 3 attempts to reduce - "$round3
				else
					echo $round3
				fi
			else
				echo $round2
			fi
		else
			echo $round1
		fi
	fi
}

function pmid2doirestful (){
	curleddoi=$(pmid2doi "$@")
	if [[ $curleddoi == '' ]]
	then
		echo "DOI NA (pmid2doirestful): $@"
	else
		echo "$curleddoi"
	fi
}
alias textemplate="vim /home/louis/R/x86_64-pc-linux-gnu-library/3.1/rmarkdown/rmd/latex/default.tex"
alias toreprise="cd ~/Dropbox/Uni\ Y2/Reprise"
alias iplay='get_iplayer 2>/dev/null'
alias iplayr='get_iplayer --type=radio 2>/dev/null'
export LD_LIBRARY_PATH=/usr/lib/i386-linux-gnu/libXm.so.4/lib:/usr/lib/x86_64-linux-gnu/libXmu.so.6.2.0/lib:/usr/lib/x86_64-linux-gnu/libXmu.so.6
function iplayrgrep 	(){ get_iplayer --type=radio 2>/dev/null | grep -i "$@" 2> /dev/null; }
function func_kanupd8	(){ kanout="$(cd ~/Dropbox/kanban/"$@"; ./bin/kanban ./data.txt; cd - > /dev/null)"; echo $(echo $(echo "$kanout" | sed "1d;\$d" | sed "s/board .*$/board\.\.\./g")); echo $(echo "$kanout" | tail -1); }
function func_kanedit	(){ vim ~/Dropbox/kanban/"$@"/data.txt && func_kanupd8 "$@"; }
function func_kanview	(){ ( xdg-open ~/Dropbox/kanban/"$@"/html/index.html &) > /dev/null 2>&1; }
function func_kancss	(){ vim ~/Dropbox/kanban/"$@"/view/board.css && func_kanupd8 "$@"; }
function yeswekanban 	  { func_kanupd8 main; 		}
function kankan 	  { func_kanedit main;		}
function seekanban 	  { func_kanview main;		}
function editkancss 	  { func_kancss main;		}
function blogkanban 	  { func_kanupd8 writing;	} 
function blogkanbanplan   { func_kanedit writing;	}
function blogkanbanview   { func_kanview writing;	}
function blogkanbancss 	  { func_kancss writing;	}
function devkanban 	  { func_kanupd8 dev;		}
function devkanbanplan 	  { func_kanedit dev;		}
function devkanbanview 	  { func_kanview dev;		}
function blogkanbancss 	  { func_kancss dev;		}
alias r3='(vlc http://open.live.bbc.co.uk/mediaselector/5/select/version/2.0/mediaset/http-icy-aac-lc-a/format/pls/vpid/bbc_radio_three.pls &) > /dev/null 2>&1; exit'
alias r4='(vlc http://www.listenlive.eu/bbcradio4.m3u &) > /dev/null 2>&1; exit'
alias r4x='(vlc http://www.listenlive.eu/bbcradio4extra.m3u &) > /dev/null 2>&1; exit'
alias rrrinse='(vlc http://relay.exequo.org/rinseradio &) > /dev/null 2&1; exit'
alias mntace='sudo mount -o ro /dev/sda4'
function vpn {
	sudo iked
	qikea &
	exit
}

function marquee() { 
	for frame in "$@"
	do
		jp2a --background=light -z "$frame" --chars=f\ \ \ && sleep 0.1
		clear
	done
}
function pingpong { pingcheck=$(chromix ping; echo $?); }
function quietly () { "$@" > /dev/null 2>&1; }
function servertogo () {
	if [[ "$@" == '' ]]
	then
		echo "chromix-server is running"
	else
		chromix "$@"
	fi
}
function clipconfirm {
	xclip -o | xclip -sel clip
	if [[ $(xclip -o) == '' ]]
	then
		echo "Nothing copied"
	else
		echo "$(xclip -o) copied to clipboard"
	fi
}
function gogochromix () {
	quietly pingpong
	if [ $pingcheck == 0 ]
	then
		# Success, execute final chromix commands
		servertogo "$@"
	else
		quietly chromix-server & killid=$!
		sleep 1
		quietly pingpong
		if [ $pingcheck == 0 ]
		then
			# Success on second attempt, exit chromix commands
			servertogo "$@"
		else
			sleep 1
			if [ $pingcheck == 0 ]
			then
				servertogo "$@"
			else
				sleep 1
				if [ $pingcheck == 0 ]
				then
					servertogo "$@"
				else
					echo "giving up"
				fi
			fi
		fi
	fi
}

function odtgrep () {
    term="$1"
    for file in *.odt; do
        unzip -p "$file" content.xml | tidy -q -xml 2> /dev/null | grep "$term";
        if [ $? -eq 0 ]; then
            echo $file;
        fi;
    done 
}

function giz {
	if [[ "$1" =~ h ]]; then
		termdown $(echo $1 | awk '{split($0,a,"h|m|s"); print a[1]*3600 + a[2]*60 + a[3]}') && mpg123 -q ~/Music/Coin-Mario.mp3;

	else
		if [[ "$1" =~ m ]]; then
			termdown $(echo $1 | awk '{split($0,a,"m|s"); print a[1]*60 + a[2]}') && mpg123 -q ~/Music/Coin-Mario.mp3;
		else termdown $(echo $1 | awk '{split($0,a,"s"); print a[1]}') && mpg123 -q ~/Music/Coin-Mario.mp3;
		fi
	fi;
}

function addtogcal {
	printf '\033[0;33mTitle\nLocation\nWhen\nDuration (mins)\033[0m\n'
	tput home
	gcalcli --reminder 30 --descr '' add | cat | sed 's/(mins): /(mins): \n/' > ~/.truthtee
	printf '\033[8;5;44t'
	clear
	echo ''
	calurl=$(head -2 ~/.truthtee | tail -1 | cut -d ' ' -f 4)
	[[ ${calurl:0:4} != 'http' ]] && tail --lines=+2 ~/.truthtee && echo "Press any key to quit" && read -d '' -s -n1 && exit
	echo "Hit enter to visit $calurl, or any other key to quit" && read -d '' -s -n1 && [[ $REPLY == $'\x20' ]] && exit
	[[ $REPLY == $'\x0a' ]] && google-chrome $calurl
}
function phdsearch (){
	allpages=''
	searchresults=''
	findaphdurl="http://www.findaphd.com/search/phd.aspx?SAID=502&FID=UK&PP=50"
	thispage=$(curl -s "$findaphdurl")
	flags=$(echo "$@" | awk -F\  '{print substr($2,2)}')
	pagecounter='0'
	pagelist=$(echo "$thispage" | grep 'PG=' |  sed 's/onclick/\n/g' | awk '{split($0,a,"window.location="); print a[2]}' | awk -F\' '{print $2}' | sort | uniq | sed '/^$/d')
	preparseIFS=$IFS
	IFS=$'\n'
	for eachpage in $(echo "$pagelist"); do
		(( pagecounter++ ))
		echo "Page $pagecounter"
		freshpage=$(curl -s $eachpage)
		allpages=$(echo -e "$allpages\n$freshpage")
	done
	ends=$(echo "$allpages" | grep -nB 4 'divStatsFooter"' | grep '</div>' | awk -F\- '{print $1}')
	means=$(echo "$allpages" | grep -n 'id="SearchResults"' | awk -F\: '{print $1}')
	parsepairs=$(paste <(echo "$means") <(echo "$ends") --delimiters '\t')
	searchresults=$(
	IFS=$'\n'
	for parsepair in ${parsepairs[@]}; do
		echo "$allpages" | sed $(echo "$parsepair" | awk -F\\t '{print $1}')","$(echo "$parsepair" | awk -F\\t '{print $2}')'!d' | tail --lines=+2 | head -n -1
	done
	)
	listingstitles=$(echo "$searchresults" | grep 'lMainLink" title' | awk '{split($0,a,"hlMainLink\" title=\""); print a[2]}' | awk -F\" '{print $1}' | sed 's/^PhD Research Project:/PhD:/g')
	listingslinks=$(echo "$searchresults" | grep 'lMainLink" title' | awk '{split($0,a,"class=\"titleLink\" href=\""); print a[2]}' | awk -F\" '{print "http://www.findaphd.com/search/"$1}')
	listings=$(paste <(echo "$listingstitles") <(echo "$listingslinks") --delimiters '\t')
#	echo $listingslinks | awk '{print $(curl -s http://is.gd/api.php?longurl=)"$0}'
#	echo "$listings"
	IFS=$preparseIFS
	echo "$listings" | expand -t 180
}
function gomakeitrun { go build; ./*; }
function gifspeedchange() {
	# args: $gif_path $frame_delay (1 = 0.1s)
        local orig_gif="${1?'Missing GIF filename parameter'}"
        local frame_delay=${2?'Missing frame delay parameter'}
	gifsicle --batch --delay $frame_delay $orig_gif
	local newframerate=$(echo "$frame_delay*10" | bc)
	echo "new GIF frame rate: $newframerate ms"
}
function gifopt() {
	# args: $input_file ($loss_level)
	if [ -z "$2" ]
	then
		# use default of 30
		local loss_level=30
	elif [[ "$2" =~ ^[0-9]+$ ]] && [ "$2" -ge 30 -a "$2" -le 200 ]
	then
		local loss_level=$2
	else
		echo "${2:-"Loss level parameter must be an integer from 30-200"}" 1>&2
		exit 1
	fi
	local inputgif="${1?'Missing input file parameter'}"
	local gifname="$(basename $inputgif .gif)"
	local basegifname=$(echo "$gifname" | sed 's/_reduced_x[0-9]//g')
	local outputgif="$basegifname-opt.gif"
	gifsicle -O3 $gifdelay --lossy="$loss_level" -o "$outputgif" "$inputgif";
	local oldfilesize=$(du -h $inputgif | cut -f1)
	local newfilesize=$(du -h $outputgif | cut -f1)
	echo "File reduced from $oldfilesize to $newfilesize as $outputgif"
}
function gif_framecount_reducer () {
	# args: $gif_path $frames_reduction_factor
	local orig_gif="${1?'Missing GIF filename parameter'}"
	local reduction_factor=${2?'Missing reduction factor parameter'}
	# Extracting the delays between each frames
	local orig_delay=$(gifsicle -I "$orig_gif" | sed -ne 's/.*delay \([0-9.]\+\)s/\1/p' | uniq)
	# Ensuring this delay is constant
	[ $(echo "$orig_delay" | wc -l) -ne 1 ] \
		&& echo "Input GIF doesn't have a fixed framerate" >&2 \
		&& return 1
	# Computing the current and new FPS
	local new_fps=$(echo "(1/$orig_delay)/$reduction_factor" | bc)
	# Exploding the animation into individual images in /var/tmp
	local tmp_frames_prefix="/var/tmp/${orig_gif%.*}_"
	convert "$orig_gif" -coalesce +adjoin "$tmp_frames_prefix%05d.gif"
	local frames_count=$(ls "$tmp_frames_prefix"*.gif | wc -l)
	# Creating a symlink for one frame every $reduction_factor
	local sel_frames_prefix="/var/tmp/sel_${orig_gif%.*}_"
	for i in $(seq 0 $reduction_factor $((frames_count-1))); do
		local suffix=$(printf "%05d.gif" $i)
		ln -s "$tmp_frames_prefix$suffix" "$sel_frames_prefix$suffix"
	done
	# Assembling the new animated GIF from the selected frames
	convert -delay $new_fps "$sel_frames_prefix"*.gif "${orig_gif%.*}_reduced_x${reduction_factor}.gif"
	# Cleaning up
	rm "$tmp_frames_prefix"*.gif "$sel_frames_prefix"*.gif
}
function howbigis () { du -h "$@"; }
