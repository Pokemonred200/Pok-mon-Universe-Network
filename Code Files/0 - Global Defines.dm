#define true 1
#define false 0

//#define PUNDEBUG
//#define OLD_PC_SYSTEM

#define checkType(type,pokemon) (type in list(pokemon.type1,pokemon.type2,pokemon.type3))

#define TILE_WIDTH 32
#define TILE_HEIGHT 32

#define ever ;;

#define TICK_LAG 10 / 30
#define FPS 30

// Movement Flags
#define MOVE_SLIDE 0x0001
#define MOVE_JUMP 0x0002
#define MOVE_TELEPORT 00004

// Time-Based things
#define SECOND 10
#define MINUTE (SECOND*60)
#define HOUR (MINUTE*60)
#define DAY (HOUR*24)
#define WEEK (DAY*7)
#define MONTH (DAY*28)
#define YEAR (DAY*365)

// Macro Procs
#define islist(x) (istype(x,/list))
#define isclient(x) (istype(x,/client))
#define isplayer(x) (istype(x,/player))
#define ispokemon(x) (istype(x,/pokemon))

// Pokémon Ability Macros
#define defeatist(x) ((("Defeatist" in list(x.ability1,x.ability2))&&((x.HP)<=(x.maxHP/2)))?(0.5):(1))

#define genderSet(genderByte,threshHold) ((genderByte>=threshHold)?("male"):("female"))

#define ceil(x) (-round(-x))

#define commafy(x) (number_commas.Replace(x,","))

proc/floor(x){. = round(x)}

// Languages
#define JAPANESE "Japanese"
#define ENGLISH "English"
#define FRENCH "French"
#define ITALIAN "Italian"
#define GERMAN "German"
#define KOREAN "Korean"
#define SPANISH "Spanish"

// Pokémon State Flags
#define HAS_LEVELED 0x0001
#define FOCUSED 0x0002
#define FORESIGHT 0x0004
#define MIRACLE_EYE 0x0008
#define GROUNDED 0x0010
#define LUCKY_CHANT 0x0020
#define PROTECTED 0x0040
#define LOCKED_ON 0x0080
#define FLINCHED 0x0100
#define LOAFING 0x0200
#define RECHARGING 0x0300
#define CHARGED 0x0400
#define MEGA_EVOLVED 0x0800

// Pokémon & Move Types
#define NORMAL "Normal"
#define GRASS "Grass"
#define FIRE "Fire"
#define WATER "Water"
#define GHOST "Ghost"
#define ROCK "Rock"
#define ELECTRIC "Electric"
#define FAIRY "Fairy"
#define BUG "Bug"
#define DRAGON "Dragon"
#define ICE "Ice"
#define DARK "Dark"
#define GROUND "Ground"
#define FLYING "Flying"
#define FIGHTING "Fighting"
#define POISON "Poison"
#define STEEL "Steel"
#define PSYCHIC "Psychic"
#define SOUND "Sound"
#define LIGHT "Light"
#define BUBBLE "Bubble"
#define FPRESS "Fpress" // Regular Flying Press
#define NPRESS "Npress" // Normal-Flying Flying Press
#define EPRESS "Epress" // Electic-Flying Flying Press
#define UNKNOWN "???"

// Contest Types
#define BEAUTY "Beauty"
#define COOL "Cool"
#define CUTE "Cute"
#define TOUGH "Tough"
#define SMART "Smart"

// EXP Groups
#define ERRATIC "Erratic"
#define FAST "Fast"
#define MEDIUM_FAST "Medium Fast"
#define MEDIUM_SLOW "Medium Slow"
#define SLOW "Slow"
#define FLUCTUATING "Fluctuating"

#define DEFAULT_ATTACK ""

// Battle Areas
#define GRASSY "Grassy"
#define BEACH "Beach"
#define CAVE "Cave"
#define URBAN "Urban"
#define FOREST "Forest"
#define POND "Pond"

// Move Ranges
#define PHYSICAL "Physical"
#define SPECIAL "Special"
#define CRUSH "Crush"
#define STATUS "Status"

// Evolution Types
#define LEVEL "Level"
#define STONE "Stone"
#define FRIENDSHIP "Friendship"
#define LEARN_MOVE "Learn Move"
#define AFFECTION "Affection" // For Sylveon, merely requires two hearts
#define OTHER "Other"
#define TRADE "Trade"
#define DAYTIME "Daytime" // Same as LEVEL, but only evolves during morning and day hours.
#define NIGHTTIME "Nighttime" // Same as LEVEL, but only evolves during evening and night hours.

// Berry Stages
#define STAGE_NOTHING "Stage Nothing"
#define STAGE_PLANTED "Stage Planted"
#define STAGE_SPROUTED "Stage Sprouted"
#define STAGE_GROWING "Stage Growing"
#define STAGE_BLOOMING "Stage Blooming"
#define STAGE_DONE "Stage Done"

// Status Conditions
#define ASLEEP "Sleep"
#define FROZEN "Frozen"
#define PARALYZED "Paralyzed"
#define POISONED "Poison"
#define BAD_POISON "Badly Poisoned"
#define BURNED "Burned"
#define FAINTED "Fainted"

// Volatile Status Conditions
#define CONFUSED "Confused"
#define BLINDED "Blinded"
#define NIGHTMARE "Nightmare"
#define INFATUATED "Infatuated"
#define ELECTRIFIED "Electrified"
#define CURSED "Cursed"

// Weather Conditons
#define CLEAR "Clear"
#define RAINY "Rain Dance"
#define THUNDERSTORM "Thunder Storm"
#define HAIL "Hail"
#define SANDSTORM "Sandstorm"
#define SUNNY "Sunny"
#define FOG "Fog"

// Entry Hazards
#define STEALTH_ROCK "Stealth Rock"
#define SPIKES "Spikes"
#define TOXIC_SPIKES "Toxic Spikes"
#define STICKY_WEB "Sticky Web"

// O. Powers
#define EXP_POINT_POWER "Exp. Point Power"

// In-Game Area Info
#define LITTLEROOT_TOWN "Littleroot Town"
#define OLDALE_TOWN "Oldale Town"
#define PETALBURG_CITY "Petalburg City"
#define PETALBURG_WOODS "Petalburg Woods"
#define RUSTBORO_CITY "Rustboro City"
#define DEWFORD_BEACH "Dewford Beach"
#define SLATEPORT_CITY "Slateport City"
#define OCEANIC_MUSEUM "Oceanic Museum"
#define MAUVILLE_CITY "Mauville City"
#define VERDANTURF_TOWN "Verdanturf Town"
#define LAVARIDGE_TOWN "Lavaridge Town"
#define ROUTE_101 "Route 101"
#define ROUTE_102 "Route 102"
#define ROUTE_103 "Route 103"
#define ROUTE_104 "Route 104"
#define ROUTE_109 "Route 109"
#define ROUTE_110 "Route 110"
#define ROUTE_111 "Route 111"
#define ROUTE_111_DESERT "Route 111 Desert"
#define ROUTE_112 "Route 112"
#define ROUTE_113 "Route 113"
#define ROUTE_114 "Route 114"
#define ROUTE_115_SOUTH "Route 115 (South)"
#define ROUTE_115_NORTH "Route 115 (North)"
#define ROUTE_116 "Route 116"
#define ROUTE_117 "Route 117"
#define JAGGED_PASS "Jagged Pass"
#define METEOR_FALLS "Meteor Falls"
#define FIREY_PATH "Firey Path"
#define POKE_CENTER "Pokémon Center"
#define POKE_MART "Pokémon Mart"
#define POKE_LAB_BIRCH "Professor Birch's Pokémon Lab"
#define PAL_PARK "Pal Park"
#define PAL_PARK_FIELD "Pal Park Field"
#define PAL_PARK_FOREST "Pal Park Forest"
#define PAL_PARK_MOUNTAIN "Pal Park Mountain"
#define PAL_PARK_POND "Pal Park Pond"
#define PAL_PARK_SEA "Pal Park Sea"
#define GRANITE_CAVE_1F "Granite Cave 1F"
#define GRANITE_CAVE_B1F "Granite Cave B1F"
#define GRANITE_CAVE_B2F "Granite Cave B2F"
#define GRANITE_CAVE_BACK_ROOM "Granite Cave Back Room"
#define RUSTURF_TUNNEL "Rusturf Tunnel"
#define STAFF_AREA "Staff Area"
#define ONE_ISLAND "One Island"
#define TWO_ISLAND "Two Island"
#define THREE_ISLAND "Three Island"
#define FOUR_ISLAND "Four Island"
#define FIVE_ISLAND "Five Island"
#define SIX_ISLAND "Six Island"
#define SEVEN_ISLAND "Seven Island"
#define KINDLE_ROAD "Kindle Road"
#define TREASURE_BEACH "Treasure Beach"
#define CAPE_BRINK "Cape Brink"
#define BOND_BRIDGE "Bond Bridge"
#define THREE_ISLE_PATH "Three Isle Path"
#define THREE_ISLE_PORT "Three Isle Port"
#define BERRY_FOREST "Berry Forest"
#define BIRTH_ISLAND "Birth Island"
#define NAVEL_ROCK "Navel Rock"
#define NEW_MOON_ISLAND "New Moon Island"

// Trainer Battle Flags
#define WILD_BATTLE 0x0001
#define TRAINER_BATTLE 0x0002
#define DOUBLE_BATTLE 0x0004
#define PVP_BATTLE 0x0008
#define TAG_BATTLE 0x0010
#define MULTI_BATTLE 0x0020
#define GRAVITY 0x0040
#define FREE_FOR_ALL 0x0080
#define FISHING_BATTLE 0x0100
#define IMPORT_BATTLE 0x0200
#define BATTLE_WON 0x0400

// PVP flags
#define NO_UPGRADES_CLAUSE 1
#define SLEEP_CLAUSE 2
#define FREEZE_CLAUSE 4
#define DUPLICATE_ITEMS_CLAUSE 8
#define SPECIES_CLAUSE 16

//money flags
#define AMULET_COIN 1
#define LUCK_INCENSE 2
#define HAPPY_HOUR 4

// Stone Constants
#define THUNDER_STONE 1
#define MOON_STONE 2
#define FIRE_STONE 4
#define WATER_STONE 8
#define SUN_STONE 16
#define LEAF_STONE 32
#define DAWN_STONE 64
#define DUSK_STONE 128
#define SHINY_STONE 256
#define ICE_STONE 512

// Pokémon Move States
#define FLIGHT 0x0001
#define DIGGING 0x0002
#define DIVING 0x0004
#define BOUNCING 0x0008
#define PHANTOM 0x0010 // This will be used for both Phantom Force and Shadow Force

// Additional Layers
#define POKEMON_LAYER 3.99

// Additional Planes
#define HUD_PLANE 5

// Costume States
#define COSTUME_WALKING "Costume Walking"
#define COSTUME_RUNNING "Costume Running"
#define COSTUME_BIKE_MOVING "Costume Bike Moving"
#define COSTUME_BIKE_IDLE "Costume Bike Idle"

// Pokemon_Flags
#define IMPORTED 0x0001
#define IMPORTED_FROM_GEN_3 0x0002
#define SHINY 0x0004
#define HIDDEN_ABILITY 0x0008
#define HIDDEN_ABILITY_2 0x0010

// Temporary Pokemon Flags
#define TRADE_SWAP_EVO 0x0001 // Used for Shelmet and Karrablast's trade evolution mechanic

// Player Flags
#define IS_LOADING 0x0001
#define IN_LOGIN 0x0002
#define IN_BATTLE 0x0004
#define CAN_TRADE 0x0008
#define RESPONDED 0x0010
#define USING_PC_BOX 0x0020
#define KARNAGE_LOCKED 0x0040
#define USING_ITEM 0x0080
#define LOADED_COSTUMES 0x0100
#define DID_MENU_STUFF 0x0200
#define TRAINER_INTERACTING 0x0400
#define LOGGING_OUT 0x0800

// General Movable Atom Flags
#define LAST_TILE_TELEPORT 0x0001

// Saved Player Flags
#define BIKING 1
#define GB_SOUNDS 2
#define MACH 4

// Storyline Flags (Group 1)
#define BOUGHT_EXP_SHARE 1
#define BEAT_ELITE_FOUR 2
#define GOT_STARTER_MEGA_STONE 4
#define GOT_VS_SEEKER 8
#define GOT_KEY_STONE 16

// Game Flags
#define RESPAWN_CHECK 0x0001
#define USE_SCALED_EXP_FORMULA 0x0002
#define TOGGLE_HP_NATURES 0x0004 // If this flag is on, HP natures will never be generated.
#define TOGGLE_OVERWORLD_POISON 0x0008 // If this flag is on, poison will deal damage outside of battle.

// Regions (In order of accessability (in full))
#define HOENN "Hoenn"
#define SEVII_ISLANDS "Sevii Islands"
#define KATOMA "Katoma"
#define JOHTO "Johto"
#define KANTO "Kanto"
#define SINNOH "Sinnoh"

// Caught Pokémon Flags
#define CAUGHT_DEOXYS 0x0001
#define CAUGHT_LUGIA 0x0002
#define CAUGHT_HO_OH 0x0004
#define CAUGHT_GROUDON 0x0008
#define CAUGHT_KYOGRE 0x0010
#define CAUGHT_RAYQUAZA 0x0020
#define CAUGHT_EON_LEGEND 0x0040
#define CAUGHT_EON_LEGEND_SOUTHERN 0x0080
#define CAUGHT_MEW 0x0100
#define CAUGHT_REGIROCK 0x0200
#define CAUGHT_REGICE 0x0400
#define CAUGHT_REGISTEEL 0x0800
#define CAUGHT_DARKRAI 0x1000

// Move Upgrade Flags
#define MOVE_UPGRADED 1
#define MOVE_UPGRADEABLE 2

// Client Flags
#define LOCK_MOVEMENT 0x0001
#define SCREEN_LOC_DEBUG 0x0002
#define GRAYSCALE_MODE 0x0004
#define INVERSION_MODE 0x0008

// Items Given Flags
#define RECIEVED_CUT 0x0001
#define RECIEVED_FLASH 0x0002
#define RECIEVED_WATERING_CAN 0x0004
#define RECIEVED_ROCK_SMASH 0x0005

// Battle Action Flag
#define BATTLE_STAGE_ACTION_SELECT 1
#define BATTLE_STAGE_MOVE_SELECT 2
#define BATTLE_STAGE_TARGET_SELECT 3
#define BATTLE_STAGE_MOVE_PROCESS 4

// Pokémon Egg Groups
#define MONSTER "Monster"
#define HUMAN_LIKE "Human-Like"
#define WATER_1 "Water 1"
#define WATER_2 "Water 2"
#define WATER_3 "Water 3"
#define UNDISCOVERED "Undiscovered"
#ifndef BUG
#define BUG "Bug"
#endif
#define MINERAL "Mineral"
#ifndef FLYING
#define FLYING "Flying"
#endif
#define AMORPHOUS "Amorphous"
#define FIELD "Field"
#ifndef FAIRY
#define FAIRY "Fairy"
#endif
#define DITTO "Ditto"
#ifndef GRASS
#define GRASS "Grass"
#endif
#ifndef DRAGON
#define DRAGON "Dragon"
#endif

#define MAX_VIEW_TILES 800
#define TILE_WIDTH 32
#define TILE_HEIGHT 32

// Pokémon Move Flags
#define SERENE_GRACE 0x0001
#define SHEER_FORCE 0x0002

#define sereneProb(x,p) (prob((x.battleFlags & SERENE_GRACE)?(p*2):(p)))

// Pokemon Sprites Defines
#define FRONT_SPRITES "Icon Files/Portrait/Battle Sprites/3D Sprites"
#define BACK_SPRITES "Icon Files/Portrait/Battle Sprites/3D Back Sprites"
#define FRONT_SHINY_SPRITES "Icon Files/Portrait/Battle Sprites/3D Shiny Sprites"
#define BACK_SHINY_SPRITES "Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites"

// Bitwise Functions
#define setBitArea(a,b,c) ((a & ~c) | (b & c))


// Pokémon Utility Functions
#define getFrontImage(z,x) ((!(z.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Sprites/[x]")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Sprites/[x]")))
#define getBackImage(z,x) ((!(z.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/[x]")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites/[x]")))
#define getMenuIcon(x,y,z) ((!(x.savedFlags & SHINY))?(icon(file("Icon Files/Portrait/Pokémon/[y]"),"[z]")):(icon(file("Icon Files/Portrait/Pokémon/Shiny [y]"),"[z]")))
