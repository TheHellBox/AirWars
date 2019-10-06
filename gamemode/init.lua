--[[
 Hello dear programmer! I'm The HellBox, 16 years old programmer from Tyumen, Russia. I hope you will be able to read my code,
 if you want to get help, just contact me on discord: The HellBox#3589

I had big problems with social life during the development,
So the code quality can be quite bad at times, just because I was getting constant headaches

The varible/file naming can be quite shitty at times, sorry (:

28 July
I realised that I made kind of mess trying to keep OOP stuff. Half of the stuff is just functions, the other half is OOP. And you know what?
Non-oop stuff works better. Shiit

30 July
This code looks like peace of shit really. A pill of garbage. I was trying to make it consistant, but there is too much going on

10 August
Can I just finish this gamemode already? I feel dumb about varible naming and code quality. I'm working on collision detection currently, such a mess there.
Also I'm not trying into lua OOP anymore, peace of shit.
And by the way, I had an idea to rewrite the whole thing today, it will take a week or something, but I better finish it at current state, or I will lose enthusiasm

14 August
I'm still alive! Collision detection kind of works, but quite unstable and I often break it. Made 3d models for cannons, looks great.
I've done some code refactoring. Not much, but it looks cleaner in some places.
Added some comments to the code
Discovered FrameTime() function, neat

16 August
Collision detection works so well! I've made it into OBB!

19 August
First beta test is done! Everything works great

29 August
Gamemode looks fantastic, it plays great, it looks great, it works fine.
But I'm getting more and more requests for new stuff in gamemode. Like pointshop, new guns, etc
I'm quite tired of development, and it's hard to keep it

3 September
School started. I've done a lot of stuff, but there is still a lot of bugs, and I need some feautures to be done.
I feel like I haven't got enough time for development, already. I will try to fix stuff and do the most impontant things, then I'll release this thingy
The optimization is a problem too, I had to set the collision detection tickrate to 0.5 seconds, otherwise it will be too slow for big fights

22 September
I'm near the finish line. Now it's time to fix bugs and do the balance.
My life is getting better btw

1 October
Fuck, fuck, fuck, I almost did it! There is almost nothing left to do! (Added flags btw)
2 October
Release at friday, shit, I'm nervous as fuck

]]

--    The HellBox

-- FIXME: Remove
--resource.AddWorkshop( "1849075184" )

GM.Version = "0.1"
GM.Name = "Air Wars"
GM.Author = "The HellBox"

AirWars = {}

include("enums.lua")
include("config.lua")
include("point_shop_config.lua")
include("shared/main.lua")
include("network_strings.lua")
include("server/main.lua")
include("concommands.lua")

AddCSLuaFile("config.lua")
AddCSLuaFile("enums.lua")
AddCSLuaFile("point_shop_config.lua")
AddCSLuaFile("cl_init.lua")

function AirWars:SpawnBuild(player)
	player:Give("weapon_physgun")
	player:Give("aw_tool_remover")
	player:Give("aw_tool_pusher")
	player:Give("aw_tool_stacker")
end

function AirWars:SpawnFight(player)
	if (player.lives or 0) <= 0 then
		return false
	end
	for k, v in pairs(ents.FindByClass("aw_player_spawn")) do
		if v:GetAWTeam() != player:GetAWTeam() then continue end
		player:SetPos(v:GetPos() + Vector(0, 0, 5))
		player.lives = player.lives - 1
		player:SetCurrentShip(player:GetAWTeam())
		player:Give("aw_melee")
		player:Give("aw_hands")
		return true
	end
	return false
end

function GM:PlayerSpawn(player)
	player:StripWeapons()
	player:ExitControl()
	player:SetCurrentShip(player:GetAWTeam())
	player:UnSpectate()
	player:SetSpectator(false)

	if game_state.state == GAME_STATE_BUILDING or game_state.state == GAME_STATE_PAUSE then
		AirWars:SpawnBuild(player)
	else
		local can_spawn = AirWars:SpawnFight(player)
		if !can_spawn then
			GAMEMODE:PlayerSpawnAsSpectator( player )
			return
		end
	end

	local hands = ents.Create("gmod_hands")
	if (IsValid(hands)) then
		hands:DoSetup(player)
		hands:Spawn()
	end
	player:SetCustomCollisionCheck( true )
	player:SetModel("models/player/Group03/male_04.mdl")
end

function GM:PlayerInitialSpawn(player)
	player:CreateAWTeam(AirWars:GenerateTeamId())
	for k, v in pairs(world_ships) do
		v:SyncToPlayer(player)
	end
	player:SetCurrentShip(player:GetAWTeam())
	player:InitializeData()
	player:SyncPlayerData()
end

function GM:PlayerSpawnAsSpectator( player )
	player:StripWeapons()
	player:Spectate( OBS_MODE_NONE )
	player:SetPos(global_config.world_center)
	player:SetSpectator(true)
	player:SetCurrentShip(-1)
end

function AirWars:GenerateTeamId()
	local id = math.floor(math.Rand(1, 1000))
	for k, v in pairs(player.GetAll()) do
		if v:AWIsInTeam(id) then
			return AirWars:GenerateTeamId()()
		end
	end
	return id
end

function addcslua_r(dir)
	print("AW: Running addcslua_r on " .. dir .. "/*")
	local files, dirs = file.Find(dir .. "/*", "LUA")
	for k, v in pairs(files) do
		print("AW: Adding " .. dir .. "/" .. v .. " to CSLua Files...")
		AddCSLuaFile(dir .. "/" .. v)
	end
	for k, v in pairs(dirs) do
		addcslua_r(dir .. "/" .. v)
	end
end

function GM:PlayerNoClip()
	if game_state.state == GAME_STATE_FIGHT then return true end
	return true
end

function GM:PlayerSpray()
	return true
end

function GM:PlayerDeathSound()
	return true
end

function GM:GetFallDamage( ply, speed )
	return 0
end

function GM:PlayerDisconnected( ply )
	 aw_leave_from_team(ply)
end

hook.Add("Initialize", "Disable Voice Icon", function()
	RunConsoleCommand("mp_show_voice_icons", "0")
end)

addcslua_r("airwars/gamemode/client")
addcslua_r("airwars/gamemode/shared")
