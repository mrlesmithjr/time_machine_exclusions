# Time Machine Exclusions

My take on excluding things from Time Machine backups. This was highly inspired
by https://github.com/stevegrunwell/asimov.

In an effort of trying to slim down Time Machine backups by not including
huge amounts of data which can easily be recreated. I needed a way to automate
the exclusions which change quite often because of development work I do. This
project is where I will be managing this.

## Requirements

Because of security measures implemented from Mojave on, we must allow
`/bin/bash` to have full Disk Access for the script to properly find
files/directories which are locked down.

### Allow Bash to have Full Disk Access

1. Open Preferences
1. Go to Security & Preferences
1. Select Full Disk Access in the list on the left
1. Click the lock to make changes
1. Click the + button on the list on the right
1. Navigate to the root of your HD
1. Press CMD+Shift+. to show all the hidden items
1. Select /bin/bash
1. Quit Preferences

## Launchd Schedule

Currently I have the scheduled run to execute every hour because I often generate
large builds, etc. which I do not intend on ever restoring. The hope is that the
scheduled task will catch most of this. This schedule can be changed in the
[com.time_machine.exclusions.plist](com.time_machine.exclusions.plist) file.

## License

MIT

## Author Information

Larry Smith Jr.

- [@mrlesmithjr](https://www.twitter.com/mrlesmithjr)
- [EverythingShouldBeVirtual](http://everythingshouldbevirtual.com)
- [mrlesmithjr@gmail.com](mailto:mrlesmithjr@gmail.com)
