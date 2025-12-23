import { world, system } from "@minecraft/server";

system.beforeEvents.startup.subscribe((initEvent) => {
    initEvent.itemComponentRegistry.registerCustomComponent("rafaworld_mod:dark_sword", {
        onHitEntity(event) {
            const hitEntity = event.hitEntity;
            // Set the target on fire for 5 seconds (100 ticks)
            system.run(() => {
                hitEntity.setOnFire(5, true);
            });
        },
        onUse(event) {
            const player = event.source;
            const viewDirection = player.getViewDirection();
            const headLocation = player.getHeadLocation();

            // Spawn position slightly in front of the player
            const spawnOffset = 1.5;
            const spawnLocation = {
                x: headLocation.x + viewDirection.x * spawnOffset,
                y: headLocation.y + viewDirection.y * spawnOffset,
                z: headLocation.z + viewDirection.z * spawnOffset
            };

            // Fire first fireball (slightly to the left)
            system.run(() => {
                const fireball1 = player.dimension.spawnEntity("rafaworld_mod:dark_fireball", {
                    x: spawnLocation.x - viewDirection.z * 0.3,
                    y: spawnLocation.y,
                    z: spawnLocation.z + viewDirection.x * 0.3
                });

                const projectile1 = fireball1.getComponent("minecraft:projectile");
                if (projectile1) {
                    projectile1.owner = player;
                    projectile1.shoot(viewDirection, { uncertainty: 0 });
                }
            });

            // Fire second fireball (slightly to the right)
            system.run(() => {
                const fireball2 = player.dimension.spawnEntity("rafaworld_mod:dark_fireball", {
                    x: spawnLocation.x + viewDirection.z * 0.3,
                    y: spawnLocation.y,
                    z: spawnLocation.z - viewDirection.x * 0.3
                });

                const projectile2 = fireball2.getComponent("minecraft:projectile");
                if (projectile2) {
                    projectile2.owner = player;
                    projectile2.shoot(viewDirection, { uncertainty: 0 });
                }
            });
        }
    });
});
