# ND_Death 

![ND_PanicButton (1)](https://github.com/lucaswydx/ND_Death/assets/112611821/3b32047b-0efa-4fdb-9884-f65675facff7)

**ND_Death** is a script for ND-Framework's FiveM game server that enhances the player experience by providing features related to player death, EMS notifications, and respawn mechanics. It allows server administrators to configure various aspects of the player's death and revival process.

## Features

- **Player Down State**: When a player's health drops below a certain threshold, they enter a downed state, displaying a timer until they can respawn.
- **EMS Notification**: When a player is downed, medical departments (EMS) are notified to respond to the player's location for revival.
- **Automatic EMS Notification**: Option to automatically notify EMS when a player is downed and in need of medical attention.
- **Admin Revive**: Admins can revive players instantly or at their downed position.
- **Customizable Respawn Timer**: Configure the amount of time a player has to respawn after being downed.
- **Customizable Respawn Text**: Customize the text displayed to players when they are downed.
- **Integration with ND_Core**: Utilizes the ND_Core framework for seamless integration and enhanced functionality.

## Configurables

The behavior and features of the ND_Death script can be customized through the provided configuration file. The following configurables are available:

- **respawnTime**: Set the time in seconds that players have to respawn after being downed.
- **respawnText**: Customize the text displayed to players when they are downed with no respawn timer.
- **respawnTextWithTimer**: Customize the text displayed to players when they are downed with a respawn timer.
- **respawnPosition**: Set the default respawn position for players.
- **respawnHeading**: Set the default heading for players upon respawn.
- **AutoNotify**: Enable or disable automatic EMS notification when a player is downed.
- **MedDept**: Define the list of job departments that are considered part of the medical team.

## Dependencies

- [ND_Core](https://github.com/ND-Framework/ND-Core): ND_Core provides essential functionalities for seamless integration.
- [ND_Characters](https://github.com/ND-Framework/ND_Characters): ND_Characters provides essential functionalities for Job Notifcations and Admin Permissions.

## Installation

1. Ensure you have the required dependencies installed.
2. Copy the contents of this repository into your server's resources folder.
3. Configure the script by modifying the `config.lua` file.
4. Add `ensure ND_Death` to your server.cfg.
**Make sure you start it after ND_Core and ND_Characters.**

## Support and Contribution

For support, bug reports, or feature requests, please create an issue on this repository. Contributions are welcome, and pull requests are encouraged.

[Discord](https://discord.gg/andys-development-857672921912836116)

Enjoy the enhanced player experience with ND_Death!
