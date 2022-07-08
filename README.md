# google2radicale
Import gmail contacts for radicale CardDAV multifilesystem vcf files

1. Export contacts from https://contacts.google.com/ using "vCard (for iOS Contacts)" option.
2. Feed this single vcf file into the script.

It will create a vcf file per contact in the current directory.

Note that file names are uniqued with uuid. This is not strictly needed, but this is how
radicale server does it. So current directory is better be empty before the process, each
new invocation will create new unique files.

Tools needed:
- bash
- base64
- curl
- sed
- uuidgen
