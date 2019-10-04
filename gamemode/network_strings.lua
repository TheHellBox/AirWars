util.AddNetworkString("aw_spawn_prop")
-- SERVER:Sync parts
util.AddNetworkString("aw_sync_parts")
-- CLIENT:Send signal to sync ship parts(Called after aw_sync_ship)
util.AddNetworkString("aw_sync_parts")
-- SERVER:Send basic information about ship
util.AddNetworkString("aw_sync_ship")
-- SERVER:Removes all the ships, respawns players
util.AddNetworkString("aw_round_reset")
-- SERVER: Assigns player to ship
util.AddNetworkString("aw_assign_ship")
-- SERVER: Sync direction of the ship
util.AddNetworkString("aw_sync_direction")
-- SERVER: Sync ship positions to prevent desync
util.AddNetworkString("aw_sync_ship_position")
-- CLIENT: Send team join request
util.AddNetworkString("aw_send_team_request")
-- SERVER: Send request to play weapon effect
util.AddNetworkString("aw_play_weapon_effect")
-- SERVER: Sync part health update
util.AddNetworkString("aw_sync_part_health")
-- SERVER: Sync game state(eg ship cost and weight, current game stage)
util.AddNetworkString("aw_sync_game_state")
-- CLIENT: Send request to create team
util.AddNetworkString("aw_change_team_name")
-- SERVER: Send request to the leader
util.AddNetworkString("aw_team_request")
-- CLIENT: Accept request
util.AddNetworkString("aw_accept_team_request")
-- CLIENT: Kick player
util.AddNetworkString("aw_team_kick_player")
-- SERVER: Make client destroy ship
util.AddNetworkString("aw_destroy_ship")
-- SERVER: Signal hit
util.AddNetworkString("aw_bullet_hit")
-- SERVER: Signal hit from players weapon
util.AddNetworkString("aw_weapon_effect")

util.AddNetworkString("aw_effect")

util.AddNetworkString("aw_player_sync_data")

util.AddNetworkString("aw_update_flag")
util.AddNetworkString("aw_sync_flag")

-- POINTSHOP:
util.AddNetworkString("aw_pointshop_wear")
util.AddNetworkString("aw_player_sync_wearables")
