extends Node

# === 音效管理器 ===
# 全局单例，管理 BGM 和 SFX

var sfx_players: Array[AudioStreamPlayer] = []
var bgm_player: AudioStreamPlayer
const MAX_SFX_CHANNELS = 8

func _ready() -> void:
	# BGM 播放器
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Master"
	add_child(bgm_player)

	# SFX 播放器池
	for i in MAX_SFX_CHANNELS:
		var p = AudioStreamPlayer.new()
		p.bus = "Master"
		add_child(p)
		sfx_players.append(p)

func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.play()
			return
	# 所有通道都在用，用第一个
	sfx_players[0].stream = stream
	sfx_players[0].volume_db = volume_db
	sfx_players[0].play()

func play_bgm(stream: AudioStream, volume_db: float = -10.0) -> void:
	bgm_player.stream = stream
	bgm_player.volume_db = volume_db
	bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()
