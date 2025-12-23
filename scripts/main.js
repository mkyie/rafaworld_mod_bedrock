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

            // Fireball speed
            const speed = 1.5;

            // Fire first fireball (slightly to the left)
            system.run(() => {
                const fireball1 = player.dimension.spawnEntity("minecraft:small_fireball", {
                    x: spawnLocation.x - viewDirection.z * 0.3,
                    y: spawnLocation.y,
                    z: spawnLocation.z + viewDirection.x * 0.3
                });

                fireball1.setRotation(player.getRotation());
                fireball1.applyImpulse({
                    x: viewDirection.x * speed,
                    y: viewDirection.y * speed,
                    z: viewDirection.z * speed
                });
            });

            // Fire second fireball (slightly to the right)
            system.run(() => {
                const fireball2 = player.dimension.spawnEntity("minecraft:small_fireball", {
                    x: spawnLocation.x + viewDirection.z * 0.3,
                    y: spawnLocation.y,
                    z: spawnLocation.z - viewDirection.x * 0.3
                });

                fireball2.setRotation(player.getRotation());
                fireball2.applyImpulse({
                    x: viewDirection.x * speed,
                    y: viewDirection.y * speed,
                    z: viewDirection.z * speed
                });
            });
        }
    });
});
