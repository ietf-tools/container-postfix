#!/bin/bash

# Simple shell-based filter. It is meant to be invoked as follows:
#       /path/to/script -f sender recipients...

# Localize these. The -G option does nothing before Postfix 2.3.
INSPECT_DIR=/var/spool/filter
SENDMAIL="/usr/sbin/sendmail -G -i" # NEVER NEVER NEVER use "-t" here.

# Exit codes from <sysexits.h>
EX_TEMPFAIL=75
EX_UNAVAILABLE=69

# Clean up when done or when aborting.
trap "rm -f in.$$" 0 1 2 3 15

# Start processing.
cd $INSPECT_DIR || {
    echo $INSPECT_DIR does not exist; exit $EX_TEMPFAIL; }

cat >in.$$ || {
    echo Cannot save mail to file; exit $EX_TEMPFAIL; }

OG=`cat in.$$ | grep -i X-MailFrom | cut -d':' -f2 | sed 's/\ //'`
if [[ "${OG}" == "" ]]; then
  OG="noreply@lists.sys.slush.ca"
fi

VERP=`cat in.$$ | grep -i Return-path | cut -d':' -f2 | sed 's/\ //'`
OR=`echo ${@} | sed 's/(.*)$//g'`

echo $SENDMAIL -f ${OG}  >/tmp/og
echo "${OR}" >/tmp/or

echo -e "Verp: ${VERP}\n$(cat in.$$)" > in.$$
$SENDMAIL -f ${OG} "${@}" <in.$$

exit $?
