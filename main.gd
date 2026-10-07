extends Node3D
# OH MY GOD! - Noyau de controle divin

const PODS := 8
const RING_R := 10.2
const ROOM_R := 17.0
const H := 10.5

const LIGHT_ON_E := 1.5
const C_DARK := Color(0.30, 0.28, 0.26)
const C_PANEL := Color(0.36, 0.33, 0.30)
const C_CYAN := Color(1.0, 0.70, 0.30)
const C_AMBER := Color(1.0, 0.66, 0.24)
const C_RED := Color(1.0, 0.28, 0.24)
const C_GOLD := Color(0.86, 0.66, 0.26)
const C_MARBLE := Color(0.66, 0.64, 0.61)
const C_SKY := Color(0.30, 0.42, 0.62)
const C_WOOD := Color(0.36, 0.23, 0.14)
const EVENT_TAG := "[!] "
const AI_MODEL := "claude-sonnet-4-6"
const Believers := preload("res://scripts/believers.gd")
const Overlay := preload("res://scripts/overlay.gd")
const CallView := preload("res://scripts/callview.gd")
const NetSync := preload("res://scripts/netsync.gd")
const Voice := preload("res://scripts/voice.gd")
const Viral := preload("res://scripts/viral.gd")
const Echoes := preload("res://scripts/echoes.gd")
const CloudTTS := preload("res://scripts/cloud_tts.gd")
const Fun := preload("res://scripts/fun.gd")
const Delivery := preload("res://scripts/delivery.gd")
const Karaoke := preload("res://scripts/karaoke.gd")
const Intern := preload("res://scripts/intern.gd")
const ChairRide := preload("res://scripts/chairride.gd")
const Missions := preload("res://scripts/missions.gd")
const Listener := preload("res://scripts/listener.gd")
const EchoWorld := preload("res://scripts/echo_world.gd")
const Character := preload("res://scripts/character.gd")
const MiniGame := preload("res://scripts/minigame.gd")
const POWER_IDS := ["sky", "coincidence", "witness", "smite"]
const EMOTES := ["wave", "dance", "laugh", "facepalm", "pray", "point", "flex", "tpose", "chicken"]
const EMOTE_SFX := {"wave": "boing", "dance": "whistle_up", "laugh": "laugh", "facepalm": "trombone", "pray": "choir", "point": "boing", "flex": "boing", "tpose": "honk", "chicken": "squeak"}
var WHO := ["SAMUEL", "J-F", "CORINNE", "MAXIME", "JULIE", "DAVE", "SOPHIE", "RENAUD"]

var player: CharacterBody3D
var cam: Camera3D
var ray: RayCast3D
var hold_point: Node3D

var hud_top: Label
var hud_rule: Label
var hud_prompt: Label
var hud_main: Label
var crosshair: Label
var vignette: ColorRect
var hud_layer: CanvasLayer
var hud_mood: Label
var hud_quota: Label
var hud_money: Label
var hud_expo: ProgressBar
var hud_strikes: Label
var hud_obj: Label

var pitch := 0.0
var t := 0.0
var msg_time := 0.0
var bob := 0.0

var ring_lights := []
var strip_mats := []
var lights_on := true

var core: Node3D
var core_mat: StandardMaterial3D
var core_light: OmniLight3D
var god_label: Label3D
var gauge_mats := []
var stat_lbls := []
var stat_bars := []
var stat_seed := []
var halo: Node3D
var earth: Node3D
var stat_t := 0.0

var pod_pos := []
var pod_yaw := []
var seat_pos := []
var phone_mats := []
var screen_mats := []
var screen_labels := []
var beam_mats := []

var MY_POD := 0
var seated := false
var stand_pos := Vector3.ZERO
var held: RigidBody3D = null

var ringing := false
var ring_left := 0.0
var next_ring := 10.0
var in_call := false
var call_human := ""
var call_motive := ""
var conviction := 0
var god_ready := true
var god_cool := 0.0
var npcs := []
var npc_t := 0.0
var lit_count := 0
var red_mat: StandardMaterial3D
var tex := {}
var ptex := {}
var outline_node: MeshInstance3D
var flashlight: SpotLight3D
var flash_on := false
var missed := 0
var hist := []
var busy := false

var task_on := false
var task_sugar := 0
var task_milk := false
var task_big := false
var task_left := 0.0
var next_task := 45.0

var money := 0
var rivals := []
var board_lbl: Label3D
var emp_lbl: Label3D
var board_t := 0.0
var god_eyes := []
var god_texts := []
var blink_t := 0.0
var day := 1
var quota := 3
var solved := 0
var expo := 0.0
var madness := 0.0

var rule := ""
var rule_kind := ""
var rule_left := 0.0
var rule_spot := Vector3.ZERO
var last_god := 0.0

var api_key := ""
var relay_fails := 0
var relay_cool := 0.0
var relay_wait := 0.0


## Le relais IA est-il utilisable en ce moment ?
func relay_ok() -> bool:
    return Relay.enabled() and relay_fails < 3 and relay_wait <= 0.0
var player_lines := 0
var used_help := false
var tutorial = null
var http: HTTPRequest
var env_res: Environment
const FpHands := preload("res://scripts/fp_hands.gd")
var fp_hands = null
var sun_light: DirectionalLight3D
const HttpStream := preload("res://scripts/http_stream.gd")
var ai_stream = null           # reponse de l'IA en streaming (la voix part avant la fin)
var st_bytes := PackedByteArray()
var st_text := ""
var st_said := ""              # replique deja affichee/dite pendant le streaming
var lat_send := 0              # mesures de latence (ms)
var lat_first := 0
var lat_say := 0
var lat_log := []              # [premier mot, replique, fin] par echange

var pc_ui: Control
var pc_status: Label
var pc_log: RichTextLabel
var pc_input: LineEdit
var pc_answer: Button
var pc_hang: Button
var pc_btns := []
var pc_god: Button
var pc_conv: Label
var pc_conv_bar: ProgressBar
var pc_video: TextureRect
var pc_video_head: Label
var pc_rec: Label
var pc_sig: Label
var pc_tag: Label
var call_t0 := 0.0
var dev_kind := ""
var slip_t := 0.0
var auto_voted := false
var auto_wait := 0.0
var emote_t := 0.0
var cushions := {}
var mass_left := 0.0
var next_mass := 200.0
var coffee_salted := false
var sabotage_cd := {}
var votes := {}
var voice = null
var hud_mic: Label
var auto_day_logged := 0
var voice_level := 0.0
var viral = null
var echoes = null
var tts = null
var fun = null
var mass_disco := false
var shamed := false
var delivery = null
var karaoke = null
var intern = null
var chairride = null
var missions = null
var listener = null
var echo_world = null
var pending_calls := []      # consequences : conjoints, proches... qui vont appeler
var hud_voicefx := ""
var cur_emote := ""
var sync = null
var avatars := {}
var remote_cv := {}
var pod_video_quads := {}
var remote_ring := {}
var rule_seen := ""
var npc_calls := {}
var my_video_quad: MeshInstance3D
var next_event := 80.0
var flicker_t := 0.0
var cam_shake := 0.0
var minigame = null
var pc_mg_btn: Button
var radio_spot: Node3D
var radio_lbl: Label3D
var radio_i := 0
var water_cd := 0.0
var hoops := 0
var last_player_line := ""
var autoplay := false
var auto_line_t := 0.0
var auto_t := 0.0
var ring_spot: Node3D
var step_phase := 0
var heart_on := false
var video_static := 0.3
var callview = null
var coffee_ui: Control
var cof_lbl: Label
var cof_sugar := 1
var cof_milk := false
var cof_big := false

var frozen := true
var paused := false
var overlay = null
var cur_b := {}
var call_lines := 0
var last_line := ""
var last_headline := ""
var used_powers := []
var active_powers := []
var shift_left := 0.0
var soon_warned := false
var quota_warned := false
var blackout_left := 0.0
var next_blackout := 40.0
var want_jump := false
var load_ok := false
var POWERS := []
var POWER_TXT := []
var SALES := []
var NPC_LINES := []
var RULES := []


func _ready() -> void:
    randomize()
    if Net.active:
        MY_POD = Net.my_pod()
        for id in Net.players:
            var pl: Dictionary = Net.players[id]
            WHO[int(pl["pod"])] = str(pl["name"])
    POWERS = Loc.list("powers")
    POWER_TXT = Loc.list("power_txt")
    SALES = Loc.list("sales")
    NPC_LINES = Loc.list("npc_lines")
    RULES = Loc.list("rules")
    _load_textures()
    for i in PODS:
        rivals.append(randi_range(200, 900))
    rivals[MY_POD] = 0
    _load_key()
    _env()
    _room()
    _office_lights()
    _billboard()
    _god_screens()
    _core()
    _pods()
    _divine()
    _alcove()
    _clutter()
    _decor()
    for i in PODS:
        if i != MY_POD and not _is_player_pod(i) and not (i == 4 and Dev.args.has("fakemate")):
            _npc(i)
    _player()
    _hud()
    http = HTTPRequest.new()
    http.timeout = 30.0
    add_child(http)
    http.request_completed.connect(_on_http)
    ai_stream = HttpStream.new()
    add_child(ai_stream)
    ai_stream.chunk.connect(_on_ai_chunk)
    ai_stream.finished.connect(_on_ai_done)
    if Net.active:
        sync = NetSync.new()
        sync.name = "NetSync"
        sync.main = self
        add_child(sync)
        voice = Voice.new()
        voice.main = self
        add_child(voice)
        echoes = Echoes.new()
        echoes.main = self
        add_child(echoes)
        Net.status.connect(_on_net_status)
    overlay = Overlay.new()
    add_child(overlay)
    overlay.start_pressed.connect(_on_start_shift)
    overlay.next_pressed.connect(_on_next_day)
    overlay.again_pressed.connect(_on_again)
    overlay.menu_pressed.connect(_on_menu)
    overlay.resume_pressed.connect(_on_resume)
    tts = CloudTTS.new()
    tts.main = self
    add_child(tts)
    fun = Fun.new()
    fun.name = "Fun"
    fun.main = self
    add_child(fun)
    delivery = Delivery.new()
    delivery.name = "Delivery"
    delivery.main = self
    add_child(delivery)
    listener = Listener.new()
    listener.main = self
    add_child(listener)
    # chaque partie repart de SA memoire (un client ne garde pas le monde de l'hote d'avant)
    Reality.reload()
    echo_world = EchoWorld.new()
    echo_world.main = self
    add_child(echo_world)
    missions = Missions.new()
    missions.main = self
    add_child(missions)
    chairride = ChairRide.new()
    chairride.main = self
    add_child(chairride)
    intern = Intern.new()
    intern.main = self
    add_child(intern)
    karaoke = Karaoke.new()
    karaoke.main = self
    add_child(karaoke)
    viral = Viral.new()
    viral.name = "Viral"
    viral.main = self
    add_child(viral)
    _update_board(false)
    _merge_static()
    _rv_matte(self)
    Sfx.stop_all()
    Sfx.loop("amb", "amb_office", -9.0)
    ring_spot = Node3D.new()
    add_child(ring_spot)
    ring_spot.global_position = pod_pos[MY_POD] + Vector3(0, 1.0, 0)
    _begin_day()


func _load_textures() -> void:
    var noms: PackedStringArray = ["pierre", "bois", "sol", "vitrail"]
    var exts: PackedStringArray = [".png", ".jpg", ".jpeg", ".webp"]
    for n in noms:
        for ext in exts:
            var p: String = "res://textures/" + n + ext
            if ResourceLoader.exists(p):
                var r = ResourceLoader.load(p)
                if r != null:
                    tex[n] = r
                    break
    if tex.size() > 0:
        print("Textures chargees : ", tex.keys())
    # textures procedurales (bruit) : pierre, bois, platre
    ptex["pierre"] = _noise_pair(0.012, 3, 0.62, 1.0, 6.0)
    ptex["bois"] = _noise_pair(0.04, 11, 0.55, 1.0, 3.0, Vector2(1.0, 0.08))
    ptex["tissu"] = _noise_pair(0.2, 5, 0.8, 1.0, 1.5)


func _noise_pair(freq: float, sd: int, lo: float, hi: float, bump: float, stretch := Vector2.ONE) -> Array:
    var fn := FastNoiseLite.new()
    fn.seed = sd
    fn.frequency = freq
    fn.fractal_octaves = 5
    fn.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
    if stretch != Vector2.ONE:
        fn.domain_warp_enabled = true
        fn.domain_warp_amplitude = 20.0
    var g := Gradient.new()
    g.set_color(0, Color(lo, lo, lo))
    g.set_color(1, Color(hi, hi, hi))
    var al := NoiseTexture2D.new()
    al.width = 512
    al.height = 512
    al.seamless = true
    al.noise = fn
    al.color_ramp = g
    var nm := NoiseTexture2D.new()
    nm.width = 512
    nm.height = 512
    nm.seamless = true
    nm.as_normal_map = true
    nm.bump_strength = bump
    nm.noise = fn
    return [al, nm]


func _tex_mat(key: String, tint: Color, scale: float, rough: float, metal := 0.0) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = tint
    m.roughness = rough
    m.metallic = metal
    if tex.has(key):
        m.albedo_texture = tex[key]
        m.uv1_triplanar = true
        m.uv1_scale = Vector3(scale, scale, scale)
    elif ptex.has(key):
        var pr: Array = ptex[key]
        m.albedo_texture = pr[0]
        m.normal_enabled = true
        m.normal_texture = pr[1]
        m.uv1_triplanar = true
        m.uv1_scale = Vector3(scale, scale, scale) * 0.6
    return m


func _load_key() -> void:
    for p in ["res://cle_api.txt", "user://cle_api.txt"]:
        if FileAccess.file_exists(p):
            var f := FileAccess.open(p, FileAccess.READ)
            if f != null:
                api_key = f.get_as_text().strip_edges()
                f.close()
                if api_key != "":
                    return


# ------------------------------------------------------------- materiaux

func _mat(c: Color, rough := 0.6, metal := 0.3) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = c
    m.roughness = rough
    m.metallic = metal
    return m


func _emit(c: Color, e := 2.0) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = c
    m.emission_enabled = true
    m.emission = c
    m.emission_energy_multiplier = e
    return m


func _glass(c: Color) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = c
    m.roughness = 0.05
    m.metallic = 0.1
    m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    return m


func _box(par: Node, pos: Vector3, size: Vector3, m: StandardMaterial3D, solid := false) -> Node3D:
    var mi := MeshInstance3D.new()
    var bm := BoxMesh.new()
    bm.size = size
    mi.mesh = bm
    mi.material_override = m
    mi.position = pos
    par.add_child(mi)
    if solid:
        var sb := StaticBody3D.new()
        var cs := CollisionShape3D.new()
        var sh := BoxShape3D.new()
        sh.size = size
        cs.shape = sh
        sb.add_child(cs)
        mi.add_child(sb)
        return sb
    return mi


func _cyl(par: Node, pos: Vector3, rt: float, rb: float, h: float, m: StandardMaterial3D, solid := false) -> Node3D:
    var mi := MeshInstance3D.new()
    var cm := CylinderMesh.new()
    cm.top_radius = rt
    cm.bottom_radius = rb
    cm.height = h
    cm.radial_segments = 28
    mi.mesh = cm
    mi.material_override = m
    mi.position = pos
    par.add_child(mi)
    if solid:
        var sb := StaticBody3D.new()
        var cs := CollisionShape3D.new()
        var sh := CylinderShape3D.new()
        sh.radius = max(rt, rb)
        sh.height = h
        cs.shape = sh
        sb.add_child(cs)
        mi.add_child(sb)
        return sb
    return mi


func _txt(par: Node, pos: Vector3, text: String, size: int, col: Color, yaw := 0.0, bill := false) -> Label3D:
    var l := Label3D.new()
    l.font = Loc.font("title")
    l.text = text
    l.font_size = size
    l.modulate = col
    l.position = pos
    l.rotation_degrees = Vector3(0, yaw, 0)
    if bill:
        l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    par.add_child(l)
    return l


# ------------------------------------------------------------- monde

func _env() -> void:
    # Ambiance « RV There Yet? » : lumiere chaude et douce, rebonds de lumiere,
    # matieres mates, couleurs saturees mais jamais criardes.
    var e := Environment.new()
    var sky := Sky.new()
    var sm := ProceduralSkyMaterial.new()
    sm.sky_top_color = Color(0.42, 0.62, 0.9)
    sm.sky_horizon_color = Color(0.95, 0.82, 0.62)
    sm.ground_horizon_color = Color(0.8, 0.62, 0.42)
    sm.ground_bottom_color = Color(0.35, 0.24, 0.16)
    sm.sun_angle_max = 20.0
    sky.sky_material = sm
    e.sky = sky
    e.background_mode = Environment.BG_SKY
    e.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    e.ambient_light_sky_contribution = 0.75
    e.ambient_light_color = Color(1.0, 0.78, 0.55)
    e.ambient_light_energy = 0.55
    e.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
    e.tonemap_mode = Environment.TONE_MAPPER_AGX
    e.tonemap_white = 6.0
    e.tonemap_exposure = 1.25
    e.glow_enabled = true
    e.glow_intensity = 0.45
    e.glow_bloom = 0.05
    e.glow_hdr_threshold = 1.3
    var q := Loc.quality
    # lumiere qui rebondit (le « look » chaud et doux)
    e.sdfgi_enabled = q >= 2
    e.sdfgi_use_occlusion = true
    e.sdfgi_energy = 1.1
    e.ssil_enabled = q >= 1
    e.ssil_intensity = 1.2
    e.ssil_radius = 4.0
    e.fog_enabled = q == 0
    e.fog_light_color = Color(0.95, 0.75, 0.5)
    e.fog_density = 0.006
    e.volumetric_fog_enabled = q >= 1
    e.volumetric_fog_density = 0.012
    e.volumetric_fog_albedo = Color(1.0, 0.86, 0.68)
    e.volumetric_fog_emission = Color(0.0, 0.0, 0.0)
    e.volumetric_fog_anisotropy = 0.6
    e.volumetric_fog_length = 48.0
    e.volumetric_fog_ambient_inject = 0.25
    e.ssao_enabled = q >= 1
    e.ssao_intensity = 1.4
    e.ssao_radius = 1.2
    e.ssao_light_affect = 0.15
    e.ssr_enabled = false
    e.adjustment_enabled = true
    e.adjustment_contrast = 0.98
    e.adjustment_saturation = 1.12
    var we := WorldEnvironment.new()
    we.environment = e
    add_child(we)
    env_res = e

    # le soleil de fin d'apres-midi (entre par les vitraux et le dome)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-42, 35, 0)
    sun.light_color = Color(1.0, 0.86, 0.66)
    sun.light_energy = 1.6
    sun.light_angular_distance = 2.5
    sun.light_volumetric_fog_energy = 1.2
    sun.shadow_enabled = true
    sun.shadow_blur = 1.5
    sun.directional_shadow_max_distance = 40.0
    add_child(sun)
    sun_light = sun

    var dust := GPUParticles3D.new()
    var pm := ParticleProcessMaterial.new()
    pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
    pm.emission_box_extents = Vector3(15, 4.0, 15)
    pm.gravity = Vector3(0, -0.03, 0)
    pm.initial_velocity_min = 0.01
    pm.initial_velocity_max = 0.05
    pm.scale_min = 0.5
    pm.scale_max = 1.4
    pm.color = Color(1.0, 0.95, 0.85, 0.3)
    dust.process_material = pm
    var qm := QuadMesh.new()
    qm.size = Vector2(0.02, 0.02)
    var dm := StandardMaterial3D.new()
    dm.albedo_color = Color(1.0, 0.96, 0.88, 0.3)
    dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    dm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
    qm.material = dm
    dust.draw_pass_1 = qm
    dust.amount = 180
    dust.lifetime = 24.0
    dust.position = Vector3(0, 3.2, 0)
    add_child(dust)


func _billboard() -> void:
    var hold := Node3D.new()
    var ba := TAU * 1.5 / 8.0
    hold.position = Vector3(sin(ba) * 12.6, 0, cos(ba) * 12.6)
    add_child(hold)
    hold.rotation.y = ba

    var wood := _wood(0.8)
    var brass := _gold(0.3)
    # cadre
    for sx0 in [-2.3, 2.3]:
        _box(hold, Vector3(sx0, 1.15, 0), Vector3(0.22, 2.3, 0.22), wood, true)
        _box(hold, Vector3(sx0, 0.06, 0), Vector3(0.5, 0.12, 0.5), wood)
    _box(hold, Vector3(0, 4.3, 0), Vector3(5.4, 4.0, 0.3), wood)
    _box(hold, Vector3(0, 4.3, -0.16), Vector3(5.1, 3.7, 0.06), brass)
    _box(hold, Vector3(0, 4.3, -0.22), Vector3(4.9, 3.4, 0.03), _emit(Color(0.09, 0.10, 0.09), 0.4))
    # fronton
    for sx in [-1.0, 1.0]:
        var sp := _box(hold, Vector3(sx * 1.7, 6.6, 0), Vector3(0.24, 1.9, 0.3), wood)
        sp.rotation_degrees = Vector3(0, 0, sx * 26.0)
    _star(hold, Vector3(0, 6.6, -0.2), 0.6, _emit(C_GOLD, 1.8), 180.0)
    _box(hold, Vector3(0, 5.85, -0.2), Vector3(5.1, 0.42, 0.04), _emit(C_GOLD, 1.3))
    _txt(hold, Vector3(0, 5.85, -0.24), Loc.t("board_title"), 36,
         Color(0.10, 0.07, 0.03), 180.0)
    board_lbl = _txt(hold, Vector3(-1.1, 4.3, -0.25), "...", 32, Color(0.75, 0.95, 0.75), 180.0)
    # cadre EMPLOYE DU MOIS
    _box(hold, Vector3(1.7, 4.35, -0.24), Vector3(1.8, 2.7, 0.06), _gold(0.3))
    _box(hold, Vector3(1.7, 4.35, -0.27), Vector3(1.62, 2.5, 0.03), _emit(Color(0.13, 0.12, 0.1), 0.5))
    _txt(hold, Vector3(1.7, 5.4, -0.29), Loc.t("emp_month"), 26, Color(1.0, 0.82, 0.45), 180.0)
    _box(hold, Vector3(1.7, 4.5, -0.29), Vector3(1.0, 1.2, 0.02), _mat(Color(0.3, 0.3, 0.34), 0.7, 0.1))
    _cyl(hold, Vector3(1.7, 4.78, -0.31), 0.22, 0.22, 0.02, _mat(Color(0.72, 0.56, 0.44), 0.8, 0.0))
    _box(hold, Vector3(1.7, 4.35, -0.31), Vector3(0.5, 0.4, 0.02), _mat(Color(0.35, 0.45, 0.6), 0.8, 0.0))
    emp_lbl = _txt(hold, Vector3(1.7, 3.5, -0.29), "---", 30, Color(1.0, 0.9, 0.6), 180.0)
    _star(hold, Vector3(1.7, 3.15, -0.29), 0.26, _emit(C_GOLD, 1.6), 180.0)
    _txt(hold, Vector3(0, 2.42, -0.24), Loc.t("board_motto"), 22,
         Color(0.7, 0.6, 0.4), 180.0)
    # lampes de tableau
    for sx2 in [-1.7, 0.0, 1.7]:
        _cyl(hold, Vector3(sx2, 6.25, -0.45), 0.04, 0.04, 0.5, brass)
        _cyl(hold, Vector3(sx2, 6.0, -0.52), 0.16, 0.08, 0.16, brass)
    var bl := OmniLight3D.new()
    bl.position = Vector3(0, 5.6, -1.2)
    bl.omni_range = 9.0
    bl.light_energy = 1.0
    bl.light_color = Color(1.0, 0.92, 0.72)
    hold.add_child(bl)
    ring_lights.append(bl)


func _god_screens() -> void:
    # quatre ecrans geants autour de la colonne : l'oeil de DIEU suit tout le monde
    var eye_sh := load("res://shaders/god_eye.gdshader")
    for q in 4:
        var a := TAU * float(q) / 4.0 + PI
        var hold := Node3D.new()
        hold.position = Vector3(-sin(a) * 1.05, 0, -cos(a) * 1.05)
        add_child(hold)
        hold.rotation.y = a
        hold.rotation_degrees.x = 0.0
        var frame := _box(hold, Vector3(0, 4.75, 0.08), Vector3(3.3, 2.3, 0.18), _mat(Color(0.06, 0.05, 0.05), 0.35, 0.7))
        frame.rotation_degrees.x = -8.0
        var gf := _box(hold, Vector3(0, 4.75, -0.03), Vector3(3.42, 2.42, 0.05), _gold(0.3))
        gf.rotation_degrees.x = -8.0
        var mi := MeshInstance3D.new()
        var qm := QuadMesh.new()
        qm.size = Vector2(3.1, 2.1)
        mi.mesh = qm
        var em := ShaderMaterial.new()
        em.shader = eye_sh
        mi.material_override = em
        mi.position = Vector3(0, 4.75, -0.07)
        mi.rotation_degrees = Vector3(-8, 180, 0)
        hold.add_child(mi)
        var l := OmniLight3D.new()
        l.position = Vector3(0, 4.6, -1.0)
        l.omni_range = 7.0
        l.light_energy = 0.6
        l.light_color = Color(1.0, 0.55, 0.2)
        l.light_volumetric_fog_energy = 0.4
        hold.add_child(l)
        _txt(hold, Vector3(0, 6.15, -0.08), Loc.t("god_watch"), 30, Color(1.0, 0.72, 0.3), 180.0)
        var txt := _txt(hold, Vector3(0, 3.35, -0.25), "", 26, Color(1.0, 0.82, 0.45), 180.0)
        txt.width = 1500
        txt.outline_size = 8
        txt.outline_modulate = Color(0, 0, 0, 0.9)
        txt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        god_texts.append(txt)
        god_eyes.append([hold, em, l])


func _office_lights() -> void:
    # dalles lumineuses de bureau, reparties en trois anneaux
    var rings := [[6.0, 6], [11.5, 10], [15.5, 10]]
    for cfg in rings:
        var rr: float = cfg[0]
        var n: int = cfg[1]
        for i in n:
            var a := TAU * float(i) / float(n)
            var p := Vector3(sin(a) * rr, 0, cos(a) * rr)
            var fm := _emit(Color(1.0, 0.98, 0.94), 2.6)
            strip_mats.append(fm)
            var fr := _box(self, p + Vector3(0, H - 0.52, 0), Vector3(2.0, 0.14, 0.5), _mat(Color(0.72, 0.73, 0.75), 0.3, 0.7))
            fr.rotation.y = a
            var pa := _box(self, p + Vector3(0, H - 0.6, 0), Vector3(1.8, 0.05, 0.38), fm)
            pa.rotation.y = a
            var l := OmniLight3D.new()
            l.position = p + Vector3(0, H - 0.75, 0)
            l.omni_range = 9.5
            l.omni_attenuation = 1.4
            l.light_energy = LIGHT_ON_E
            l.light_color = Color(1.0, 0.9, 0.78)
            l.light_volumetric_fog_energy = 0.35
            l.shadow_enabled = (Loc.quality >= 2 and rr > 10.0 and i % 5 == 0)
            add_child(l)
            ring_lights.append(l)


func _star(par: Node, pos: Vector3, size: float, m: StandardMaterial3D, yaw := 0.0) -> void:
    var h := Node3D.new()
    h.position = pos
    h.rotation_degrees = Vector3(0, yaw, 0)
    par.add_child(h)
    for k in 2:
        var p1 := MeshInstance3D.new()
        var b1 := BoxMesh.new()
        b1.size = Vector3(size * 0.16, size, 0.012)
        p1.mesh = b1
        p1.material_override = m
        p1.rotation_degrees = Vector3(0, 0, float(k) * 90.0)
        h.add_child(p1)
    for k in 2:
        var p2 := MeshInstance3D.new()
        var b2 := BoxMesh.new()
        b2.size = Vector3(size * 0.09, size * 0.62, 0.012)
        p2.mesh = b2
        p2.material_override = m
        p2.rotation_degrees = Vector3(0, 0, 45.0 + float(k) * 90.0)
        h.add_child(p2)


func _marble() -> StandardMaterial3D:
    return _tex_mat("sol", Color(1, 1, 1) if tex.has("sol") else C_MARBLE, 0.45, 0.5, 0.05)


func _stone(v := 1.0) -> StandardMaterial3D:
    return _tex_mat("pierre", Color(0.56 * v + 0.44, 0.545 * v + 0.44, 0.515 * v + 0.44) if tex.has("pierre") else Color(0.56 * v, 0.545 * v, 0.515 * v), 0.33, 0.8)


func _wood(v := 1.0) -> StandardMaterial3D:
    var c := Color(C_WOOD.r * v, C_WOOD.g * v, C_WOOD.b * v)
    if tex.has("bois"):
        c = Color(0.55 + 0.45 * v, 0.5 + 0.45 * v, 0.46 + 0.45 * v)
    return _tex_mat("bois", c, 0.6, 0.6, 0.05)


func _gold(rough := 0.25) -> StandardMaterial3D:
    return _mat(C_GOLD, rough, 1.0)


func _beam_mat(c: Color, a := 0.18) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = Color(c.r, c.g, c.b, a)
    m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
    m.cull_mode = BaseMaterial3D.CULL_DISABLED
    return m


func _candle(par: Node, p: Vector3, h := 0.22, rng := 4.5, energy := 0.0) -> void:
    _cyl(par, p + Vector3(0, h * 0.5, 0), 0.028, 0.032, h, _mat(Color(0.93, 0.89, 0.78), 0.8, 0.0))
    _cyl(par, p + Vector3(0, h + 0.035, 0), 0.006, 0.018, 0.07, _emit(Color(1.0, 0.72, 0.30), 4.0))
    if energy <= 0.0:
        return
    var l := OmniLight3D.new()
    l.position = p + Vector3(0, h + 0.09, 0)
    l.omni_range = rng
    l.light_energy = energy
    l.light_color = Color(1.0, 0.70, 0.36)
    par.add_child(l)


func _vitrail(a: float) -> void:
    var hold := Node3D.new()
    hold.position = Vector3(sin(a) * (ROOM_R - 0.12), 0, cos(a) * (ROOM_R - 0.12))
    add_child(hold)
    hold.rotation.y = a

    var hue := randf()
    var tint := Color.from_hsv(hue, 0.55, 1.0)
    # niche en ogive
    _box(hold, Vector3(0, 3.6, 0.12), Vector3(2.5, 5.0, 0.3), _stone(0.7))
    for sx in [-1.0, 1.0]:
        var sp := _box(hold, Vector3(sx * 0.62, 6.5, 0.1), Vector3(0.12, 2.3, 0.3), _stone(0.8))
        sp.rotation_degrees = Vector3(0, 0, sx * 26.0)
    # panneau image si la texture existe
    if tex.has("vitrail"):
        var vm := StandardMaterial3D.new()
        vm.albedo_texture = tex["vitrail"]
        vm.emission_enabled = true
        vm.set_texture(BaseMaterial3D.TEXTURE_EMISSION, tex["vitrail"])
        vm.emission = Color(1, 1, 1)
        vm.emission_energy_multiplier = 1.6
        vm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
        var mi5 := MeshInstance3D.new()
        var qm5 := QuadMesh.new()
        qm5.size = Vector2(2.3, 5.2)
        mi5.mesh = qm5
        mi5.material_override = vm
        mi5.position = Vector3(0, 4.0, -0.04)
        mi5.rotation_degrees = Vector3(0, 180, 0)
        hold.add_child(mi5)
    # panneaux de verre colore (secours sans texture)
    for r in (0 if tex.has("vitrail") else 7):
        for c in 3:
            var w: float = 0.62 if r < 5 else (0.46 if r == 5 else 0.3)
            var gy: float = 1.5 + float(r) * 0.66
            var gc := Color.from_hsv(fposmod(hue + float(r) * 0.07 + float(c) * 0.11, 1.0), 0.65, 1.0)
            var gm := _emit(gc, 1.5)
            _box(hold, Vector3((float(c) - 1.0) * w, gy, -0.02), Vector3(w * 0.88, 0.6, 0.04), gm)
    # plombs
    for r in 8:
        _box(hold, Vector3(0, 1.2 + float(r) * 0.66, -0.05), Vector3(2.0, 0.045, 0.06), _stone(0.35))
    for c in 4:
        _box(hold, Vector3((float(c) - 1.5) * 0.64, 3.6, -0.05), Vector3(0.05, 4.8, 0.06), _stone(0.35))
    # rosace
    var rt := TorusMesh.new()
    rt.inner_radius = 0.42
    rt.outer_radius = 0.5
    rt.rings = 24
    var rmi := MeshInstance3D.new()
    rmi.mesh = rt
    rmi.material_override = _stone(0.4)
    rmi.position = Vector3(0, 6.6, -0.05)
    rmi.rotation_degrees = Vector3(90, 0, 0)
    hold.add_child(rmi)
    _cyl(hold, Vector3(0, 6.6, -0.03), 0.44, 0.44, 0.04, _emit(tint, 2.4))

    # lumiere coloree qui entre (un vitrail sur deux porte une source)
    if lit_count % 2 == 1:
        lit_count += 1
        return
    lit_count += 1
    var sl := SpotLight3D.new()
    sl.position = Vector3(0, 4.2, -0.4)
    sl.rotation_degrees = Vector3(-32, 180, 0)
    sl.light_color = tint
    sl.light_energy = 2.4
    sl.light_volumetric_fog_energy = 3.0
    sl.shadow_enabled = Loc.quality >= 2
    sl.spot_range = 18.0
    sl.spot_angle = 34.0
    hold.add_child(sl)
    _cyl(hold, Vector3(0, 2.6, -2.4), 0.9, 2.0, 5.4, _beam_mat(tint, 0.022))


func _pillar(a: float, r: float) -> void:
    var p := Vector3(sin(a) * r, 0, cos(a) * r)
    _box(self, p + Vector3(0, 0.22, 0), Vector3(1.2, 0.44, 1.2), _stone(0.75), true)
    _cyl(self, p + Vector3(0, 3.6, 0), 0.42, 0.52, 6.8, _stone(0.95), true)
    for k in 4:
        var ca := TAU * float(k) / 4.0 + 0.4
        var fl := _box(self, p + Vector3(sin(ca) * 0.48, 3.6, cos(ca) * 0.48), Vector3(0.14, 6.8, 0.14), _stone(0.8))
        fl.rotation.y = ca
    _cyl(self, p + Vector3(0, 7.1, 0), 0.66, 0.5, 0.42, _stone(0.7))
    _cyl(self, p + Vector3(0, 7.36, 0), 0.7, 0.7, 0.12, _gold(0.4))
    # bougie murale
    _box(self, p + Vector3(0, 2.3, 0) - p.normalized() * 0.5, Vector3(0.26, 0.06, 0.26), _gold(0.35))
    _candle(self, p + Vector3(0, 2.36, 0) - p.normalized() * 0.5, 0.2)


func _vault(a: float) -> void:
    # nervure qui monte du pilier vers le centre
    var steps := 7
    for k in steps:
        var tt: float = float(k) / float(steps - 1)
        var r: float = lerp(ROOM_R - 2.7, 2.2, tt)
        var y: float = lerp(7.4, H - 0.4, sin(tt * PI * 0.5))
        var seg := _box(self, Vector3(sin(a) * r, y, cos(a) * r), Vector3(0.26, 0.3, 2.1), _stone(0.6))
        seg.rotation.y = a
        seg.rotation.x = -0.45 * (1.0 - tt)


func _banner(a: float, txt: String) -> void:
    var hold := Node3D.new()
    hold.position = Vector3(sin(a) * (ROOM_R - 1.5), 0, cos(a) * (ROOM_R - 1.5))
    add_child(hold)
    hold.rotation.y = a
    _box(hold, Vector3(0, 4.9, 0), Vector3(1.9, 2.6, 0.05), _mat(Color(0.45, 0.10, 0.12), 0.85, 0.0))
    _box(hold, Vector3(0, 6.22, 0), Vector3(2.1, 0.08, 0.1), _gold(0.4))
    _box(hold, Vector3(0, 3.62, 0), Vector3(1.9, 0.14, 0.08), _gold(0.4))
    _star(hold, Vector3(0, 5.75, -0.04), 0.5, _emit(C_GOLD, 1.6), 180.0)
    var l := _txt(hold, Vector3(0, 4.55, -0.05), txt, 40, Color(0.95, 0.85, 0.55), 180.0)
    l.width = 420
    l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _pew(a: float, r: float) -> void:
    var hold := Node3D.new()
    hold.position = Vector3(sin(a) * r, 0, cos(a) * r)
    add_child(hold)
    hold.rotation.y = a
    _box(hold, Vector3(0, 0.46, 0), Vector3(2.6, 0.1, 0.42), _wood(), true)
    _box(hold, Vector3(0, 0.78, 0.22), Vector3(2.6, 0.72, 0.09), _wood(0.85))
    for sx in [-1.15, 1.15]:
        _box(hold, Vector3(sx, 0.23, 0), Vector3(0.12, 0.46, 0.4), _wood(0.7))


func _room() -> void:
    var stone := _stone()
    var gold := _gold()

    # dallage
    var floor_m: Material = _tex_mat("sol", Color(1, 1, 1), 0.28, 0.45, 0.08)
    if not tex.has("sol"):
        var fsm := ShaderMaterial.new()
        fsm.shader = load("res://shaders/floor.gdshader")
        floor_m = fsm
    var fl := MeshInstance3D.new()
    var fcm := CylinderMesh.new()
    fcm.top_radius = ROOM_R + 1.0
    fcm.bottom_radius = ROOM_R + 1.0
    fcm.height = 0.2
    fcm.radial_segments = 64
    fl.mesh = fcm
    fl.material_override = floor_m
    fl.position = Vector3(0, -0.1, 0)
    add_child(fl)
    var fsb := StaticBody3D.new()
    var fcs := CollisionShape3D.new()
    var fsh := CylinderShape3D.new()
    fsh.radius = ROOM_R + 1.0
    fsh.height = 0.2
    fcs.shape = fsh
    fsb.add_child(fcs)
    fl.add_child(fsb)
    for i in 48:
        var a := TAU * float(i) / 48.0
        for rr in [6.5, 13.0]:
            var tile := _box(self, Vector3(sin(a) * rr, 0.012, cos(a) * rr), Vector3(TAU * rr / 48.0 + 0.04, 0.025, 0.1), _mat(Color(0.68, 0.655, 0.62), 0.45, 0.12))
            tile.rotation.y = a
    for i in 40:
        var a := TAU * float(i) / 40.0
        var gm := _emit(C_GOLD, 1.0)
        strip_mats.append(gm)
        var g := _box(self, Vector3(sin(a) * 11.0, 0.013, cos(a) * 11.0), Vector3(TAU * 11.0 / 40.0 + 0.06, 0.03, 0.08), gm)
        g.rotation.y = a

    # plafond
    _cyl(self, Vector3(0, H + 0.2, 0), ROOM_R + 1.0, ROOM_R + 1.0, 0.4, _stone(1.15), true)

    # murs, vitraux, piliers, voutes
    var seg := 16
    var wseg: float = TAU * (ROOM_R + 0.4) / float(seg) + 0.4
    for i in seg:
        var a := TAU * float(i) / float(seg)
        var w := _box(self, Vector3(sin(a) * (ROOM_R + 0.4), H * 0.5, cos(a) * (ROOM_R + 0.4)), Vector3(wseg, H, 0.6), stone, true)
        var wm: Node3D = w.get_parent()
        wm.rotation.y = a
        _vitrail(a)
        _pillar(a + TAU / float(seg) * 0.5, ROOM_R - 2.2)
        _vault(a + TAU / float(seg) * 0.5)

    # banderoles d'entreprise
    var slogans: Array = Loc.list("slogans")
    for i in slogans.size():
        _banner(TAU * (float(i) + 0.5) / 6.0, str(slogans[i]))

    # lustres en fer forge avec bougies
    for i in 4:
        var a := TAU * (float(i) + 0.5) / 4.0
        var p := Vector3(sin(a) * 12.5, 0, cos(a) * 12.5)
        _cyl(self, p + Vector3(0, H - 1.1, 0), 0.025, 0.025, 2.0, _mat(Color(0.12, 0.11, 0.1), 0.6, 0.6))
        var tm := TorusMesh.new()
        tm.inner_radius = 0.85
        tm.outer_radius = 0.92
        tm.rings = 28
        var mi := MeshInstance3D.new()
        mi.mesh = tm
        mi.material_override = _mat(Color(0.14, 0.12, 0.1), 0.6, 0.7)
        mi.position = p + Vector3(0, H - 2.1, 0)
        add_child(mi)
        for k in 8:
            var ca := TAU * float(k) / 8.0
            _candle(self, p + Vector3(sin(ca) * 0.88, H - 2.05, cos(ca) * 0.88), 0.26)
        var cl := OmniLight3D.new()
        cl.position = p + Vector3(0, H - 2.1, 0)
        cl.omni_range = 13.0
        cl.light_energy = 1.1
        cl.light_color = Color(1.0, 0.76, 0.42)
        add_child(cl)

    # bancs d'eglise en periphere
    for i in 6:
        _pew(TAU * (float(i) + 0.33) / 6.0, ROOM_R - 5.6)

    # classeurs de bureau contre les piliers
    for i in 4:
        var a := TAU * (float(i) + 0.5) / 4.0 + 0.3
        var hold := Node3D.new()
        hold.position = Vector3(sin(a) * (ROOM_R - 1.4), 0, cos(a) * (ROOM_R - 1.4))
        add_child(hold)
        hold.rotation.y = a
        _box(hold, Vector3(0, 0.78, 0), Vector3(1.1, 1.56, 0.62), _mat(Color(0.30, 0.31, 0.29), 0.5, 0.5), true)
        for k in 4:
            _box(hold, Vector3(0, 0.3 + float(k) * 0.36, -0.32), Vector3(0.9, 0.04, 0.03), _mat(Color(0.5, 0.5, 0.48), 0.3, 0.8))
        _box(hold, Vector3(0, 1.62, 0), Vector3(1.0, 0.1, 0.5), _wood(0.9))

    _wall_screens()
    _door()


func _door() -> void:
    var a := PI
    var hold := Node3D.new()
    hold.position = Vector3(sin(a) * (ROOM_R - 0.3), 0, cos(a) * (ROOM_R - 0.3))
    add_child(hold)
    hold.rotation.y = a
    _box(hold, Vector3(0, 1.8, 0), Vector3(3.2, 3.6, 0.35), _stone(0.65))
    for sx in [-1.2, 1.2]:
        var sp := _box(hold, Vector3(sx * 0.55, 4.1, 0), Vector3(0.2, 1.9, 0.35), _stone(0.65))
        sp.rotation_degrees = Vector3(0, 0, sx * 24.0)
    _box(hold, Vector3(0, 1.6, -0.2), Vector3(2.4, 3.2, 0.1), _wood(0.8), true)
    for k in 4:
        _box(hold, Vector3(0, 0.5 + float(k) * 0.85, -0.26), Vector3(2.3, 0.1, 0.05), _mat(Color(0.14, 0.12, 0.1), 0.5, 0.7))
    _box(hold, Vector3(0, 1.6, -0.27), Vector3(0.1, 3.0, 0.04), _mat(Color(0.14, 0.12, 0.1), 0.5, 0.7))
    _txt(hold, Vector3(0, 3.5, -0.3), Loc.t("exit_door"), 34, Color(0.9, 0.45, 0.35), 180.0)


func _core() -> void:
    core = Node3D.new()
    add_child(core)

    # autel a trois marches
    for k in 3:
        var rr: float = 4.2 - float(k) * 0.55
        _cyl(self, Vector3(0, 0.1 + float(k) * 0.2, 0), rr, rr + 0.1, 0.2, _stone(0.85), true)
    _cyl(self, Vector3(0, 0.72, 0), 3.0, 3.1, 0.12, _marble(), true)
    _cyl(self, Vector3(0, 0.79, 0), 3.0, 3.0, 0.03, _emit(C_GOLD, 1.4))
    _box(self, Vector3(0, 1.05, 0), Vector3(2.6, 0.5, 1.4), _wood(0.9), true)
    _box(self, Vector3(0, 1.32, 0), Vector3(2.8, 0.06, 1.6), _gold(0.35))
    for sx in [-1.0, 1.0]:
        _candle(self, Vector3(sx, 1.35, 0.5), 0.5, 9.0, 0.9)

    # colonne de lumiere divine
    core_mat = _emit(Color(1.0, 0.74, 0.32), 2.6)
    _cyl(self, Vector3(0, 4.6, 0), 0.62, 0.72, 6.4, core_mat, true)
    for k in 4:
        var a := TAU * float(k) / 4.0
        var r := _box(self, Vector3(sin(a) * 0.74, 4.6, cos(a) * 0.74), Vector3(0.12, 6.4, 0.12), _gold(0.3))
        r.rotation.y = a
    _cyl(self, Vector3(0, 1.5, 0), 1.0, 1.1, 0.28, _gold(0.35))
    _cyl(self, Vector3(0, 7.9, 0), 1.1, 0.8, 0.3, _gold(0.35))

    core_light = OmniLight3D.new()
    core_light.position = Vector3(0, 4.0, 0)
    core_light.omni_range = 14.0
    core_light.light_energy = 2.4
    core_light.light_color = Color(1.0, 0.72, 0.34)
    add_child(core_light)

    for k in 3:
        var tm := TorusMesh.new()
        tm.inner_radius = 1.3 + float(k) * 0.42
        tm.outer_radius = 1.4 + float(k) * 0.42
        tm.rings = 40
        var mi := MeshInstance3D.new()
        mi.mesh = tm
        mi.material_override = _emit(Color(1.0, 0.80, 0.42), 2.6)
        mi.position = Vector3(0, 5.9 + float(k) * 0.45, 0)
        core.add_child(mi)

    god_label = _txt(self, Vector3(0, 8.9, 0), "G.O.D.", 90, Color(1.0, 0.82, 0.45), 0.0, true)
    god_label.width = 1100
    god_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

    # tableau des cantiques = quota du jour
    for sgn in [-1.0, 1.0]:
        var hold := Node3D.new()
        hold.position = Vector3(sgn * 3.6, 0, 0)
        add_child(hold)
        hold.rotation.y = sgn * PI * 0.5
        _box(hold, Vector3(0, 1.7, 0), Vector3(1.5, 2.0, 0.1), _wood(0.75))
        _box(hold, Vector3(0, 1.7, -0.06), Vector3(1.3, 1.8, 0.02), _mat(Color(0.08, 0.07, 0.06), 0.8, 0.0))
        _txt(hold, Vector3(0, 2.35, -0.08), Loc.t("quota_board"), 30, Color(0.9, 0.8, 0.55), 180.0)
        var q := _txt(hold, Vector3(0, 1.5, -0.08), "---", 44, Color(1.0, 0.85, 0.45), 180.0)
        stat_lbls.append(q)
        stat_seed.append(-1.0)
        stat_bars.append([])
        _cyl(hold, Vector3(0, 0.4, 0), 0.08, 0.14, 0.8, _wood(0.6), true)

    # comptoir de livraison
    var aa := TAU * 4.5 / 8.0
    var tp2 := Vector3(sin(aa) * 7.2, 0, cos(aa) * 7.2)
    var tray := _cyl(self, tp2 + Vector3(0, 0.48, 0), 0.46, 0.4, 0.95, _wood(0.9), true)
    tray.set_meta("kind", "altar")
    _cyl(self, tp2 + Vector3(0, 0.97, 0), 0.56, 0.56, 0.07, _gold(0.3))
    _cyl(self, tp2 + Vector3(0, 1.02, 0), 0.44, 0.44, 0.02, _emit(Color(1.0, 0.78, 0.38), 2.4))
    _txt(self, tp2 + Vector3(0, 1.36, 0), Loc.t("offer_counter"), 28, Color(1.0, 0.82, 0.45), 0.0, true)
    _candle(self, tp2 + Vector3(0.3, 1.0, 0), 0.18)

    for i in 24:
        var a := TAU * float(i) / 24.0
        var gm2 := _emit(Color(0.25, 0.22, 0.2), 0.3)
        gauge_mats.append(gm2)
        var g2 := _box(self, Vector3(sin(a) * 4.35, 0.52, cos(a) * 4.35), Vector3(0.24, 0.5, 0.08), gm2)
        g2.rotation.y = a


func _divine() -> void:
    halo = Node3D.new()
    halo.position = Vector3(0, 7.6, 0)
    add_child(halo)
    for k in 2:
        var tm := TorusMesh.new()
        tm.inner_radius = 2.6 + float(k) * 1.2
        tm.outer_radius = 2.74 + float(k) * 1.2
        tm.rings = 56
        var mi := MeshInstance3D.new()
        mi.mesh = tm
        mi.material_override = _emit(Color(1.0, 0.80, 0.42), 2.4)
        mi.position = Vector3(0, -float(k) * 0.45, 0)
        halo.add_child(mi)
    for k in 12:
        var a := TAU * float(k) / 12.0
        var g := _box(halo, Vector3(sin(a) * 3.5, -0.8, cos(a) * 3.5), Vector3(0.07, 1.0, 0.07), _emit(C_GOLD, 1.6))
        g.rotation.y = a

    earth = Node3D.new()
    earth.position = Vector3(0, 2.9, -3.3)
    add_child(earth)
    var sp := SphereMesh.new()
    sp.radius = 0.78
    sp.height = 1.56
    sp.radial_segments = 36
    sp.rings = 18
    var gm3 := StandardMaterial3D.new()
    gm3.albedo_color = Color(1.0, 0.78, 0.4, 0.26)
    gm3.emission_enabled = true
    gm3.emission = Color(1.0, 0.74, 0.34)
    gm3.emission_energy_multiplier = 1.5
    gm3.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    gm3.cull_mode = BaseMaterial3D.CULL_DISABLED
    var em := MeshInstance3D.new()
    em.mesh = sp
    em.material_override = gm3
    earth.add_child(em)
    for k in 4:
        var tm3 := TorusMesh.new()
        var rr: float = 0.79 * sin(PI * float(k + 1) / 5.0)
        tm3.inner_radius = rr - 0.012
        tm3.outer_radius = rr + 0.012
        tm3.rings = 26
        var mi3 := MeshInstance3D.new()
        mi3.mesh = tm3
        mi3.material_override = _emit(Color(1.0, 0.88, 0.55), 2.4)
        mi3.position = Vector3(0, 0.79 * cos(PI * float(k + 1) / 5.0), 0)
        earth.add_child(mi3)
    for k in 5:
        var tm4 := TorusMesh.new()
        tm4.inner_radius = 0.78
        tm4.outer_radius = 0.80
        tm4.rings = 26
        var mi4 := MeshInstance3D.new()
        mi4.mesh = tm4
        mi4.material_override = _emit(Color(1.0, 0.86, 0.5), 1.8)
        mi4.rotation_degrees = Vector3(90, float(k) * 36.0, 0)
        earth.add_child(mi4)


func _screen(a: float, title: String, lines: String, accent: Color, bars: int) -> void:
    var hold := Node3D.new()
    hold.position = Vector3(sin(a) * (ROOM_R - 3.7), 2.8, cos(a) * (ROOM_R - 3.7))
    add_child(hold)
    hold.rotation.y = a

    _box(hold, Vector3(0, 0, 0), Vector3(3.5, 2.3, 0.2), _wood(0.8))
    _box(hold, Vector3(0, 0, -0.1), Vector3(3.3, 2.1, 0.06), _gold(0.35))
    _box(hold, Vector3(0, 0, -0.15), Vector3(3.05, 1.85, 0.03), _emit(Color(0.07, 0.09, 0.08), 0.3))
    _box(hold, Vector3(0, 0.78, -0.17), Vector3(3.05, 0.3, 0.02), _emit(accent, 1.4))
    _txt(hold, Vector3(0, 0.78, -0.2), title, 42, Color(0.06, 0.05, 0.04), 180.0)
    var body := _txt(hold, Vector3(0, 0.14, -0.2), lines, 38, Color(0.65, 0.95, 0.70), 180.0)
    stat_lbls.append(body)
    stat_seed.append(randf() * 10.0)

    var row := []
    for k in bars:
        var x: float = -1.3 + float(k) * (2.6 / float(max(1, bars - 1)))
        _box(hold, Vector3(x, -0.7, -0.18), Vector3(0.2, 0.45, 0.01), _emit(Color(0.14, 0.2, 0.16), 0.4))
        var bmi := _box(hold, Vector3(x, -0.86, -0.19), Vector3(0.18, 0.28, 0.012), _emit(accent, 1.8))
        row.append(bmi)
    stat_bars.append(row)
    _candle(hold, Vector3(-1.9, -1.2, -0.1), 0.2)
    _candle(hold, Vector3(1.9, -1.2, -0.1), 0.2)


func _wall_screens() -> void:
    var cols := [[C_GOLD, 7], [Color(0.95, 0.65, 0.25), 7], [Color(0.9, 0.4, 0.3), 6], [Color(0.5, 0.8, 0.5), 7],
                 [Color(0.5, 0.7, 0.95), 6], [Color(0.92, 0.78, 0.35), 5], [Color(0.85, 0.5, 0.7), 7]]
    var txts: Array = Loc.list("screens")
    var data := []
    for k in txts.size():
        data.append([txts[k][0], txts[k][1], cols[k][0], cols[k][1]])
    for i in data.size():
        var a := TAU * (float(i) + 0.5) / 7.0 + 0.25
        var d: Array = data[i]
        _screen(a, str(d[0]), str(d[1]), d[2], int(d[3]))


func _pods() -> void:
    for i in PODS:
        var a := TAU * float(i) / float(PODS)
        var p := Vector3(sin(a) * RING_R, 0.0, cos(a) * RING_R)
        pod_pos.append(p)
        var pod := Node3D.new()
        pod.position = p
        add_child(pod)
        pod.look_at(Vector3.ZERO, Vector3.UP)
        _pod(pod, i)
        pod_yaw.append(pod.global_rotation.y)
        seat_pos.append(pod.to_global(Vector3(0, 0.0, 0.78)))


func _pod(pod: Node3D, i: int) -> void:
    var wood := _wood()
    var wood2 := _wood(0.75)
    var brass := _gold(0.3)
    var dark := _mat(Color(0.10, 0.09, 0.085), 0.5, 0.3)
    var paper := _mat(Color(0.82, 0.78, 0.68), 0.9, 0.0)

    # pupitre de bureau en chene, ouvert vers le centre
    _box(pod, Vector3(0, 0.77, -0.3), Vector3(2.2, 0.1, 0.95), wood, true)
    _box(pod, Vector3(-1.45, 0.77, 0.05), Vector3(0.95, 0.1, 0.9), wood, true)
    _box(pod, Vector3(1.45, 0.77, 0.05), Vector3(0.95, 0.1, 0.9), wood, true)
    _box(pod, Vector3(0, 0.825, -0.78), Vector3(2.24, 0.03, 0.06), brass)
    _box(pod, Vector3(0, 0.825, 0.18), Vector3(2.24, 0.03, 0.06), brass)
    # caissons sculptes
    for sx in [-1.45, 1.45]:
        _box(pod, Vector3(sx, 0.37, 0.05), Vector3(0.82, 0.74, 0.82), wood2, true)
        for k in 3:
            _box(pod, Vector3(sx, 0.17 + float(k) * 0.22, 0.46), Vector3(0.56, 0.16, 0.02), _wood(0.6))
            _cyl(pod, Vector3(sx, 0.17 + float(k) * 0.22, 0.49), 0.035, 0.035, 0.04, brass)
    # panneau de pudeur a l'avant, genoux libres dessous
    _box(pod, Vector3(0, 0.45, -0.74), Vector3(2.1, 0.62, 0.05), _wood(0.6))
    _box(pod, Vector3(0, 0.76, -0.74), Vector3(2.16, 0.04, 0.09), brass)
    _star(pod, Vector3(0, 0.45, -0.78), 0.3, brass, 180.0)

    # ecran cathodique sur l'aile gauche : la vue vers le centre reste libre
    var mon := Node3D.new()
    mon.position = Vector3(-0.95, 0, -0.15)
    mon.rotation_degrees = Vector3(0, 30, 0)
    pod.add_child(mon)
    _box(mon, Vector3(0, 1.28, -0.22), Vector3(1.3, 0.9, 0.44), wood2)
    _box(mon, Vector3(0, 1.28, 0.02), Vector3(1.38, 0.96, 0.05), brass)
    var sm := _emit(Color(0.25, 0.45, 0.70), 1.2)
    screen_mats.append(sm)
    _box(mon, Vector3(0, 1.28, 0.05), Vector3(1.14, 0.76, 0.02), sm)
    var gl := _txt(mon, Vector3(0, 1.28, 0.08), Loc.f("pod_label", [i + 1, WHO[i]]), 30, Color(0.9, 0.97, 1.0), 0.0)
    gl.width = 300
    gl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    screen_labels.append(gl)
    if i == MY_POD or _is_player_pod(i) or (i == 4 and Dev.args.has("fakemate")):
        # l'ecran du poste affiche aussi l'appel video (visible debout)
        var vqi := MeshInstance3D.new()
        var vq := QuadMesh.new()
        vq.size = Vector2(1.12, 0.74)
        vqi.mesh = vq
        vqi.position = Vector3(0, 1.28, 0.066)
        vqi.visible = false
        mon.add_child(vqi)
        pod_video_quads[i] = vqi
        if i == MY_POD:
            my_video_quad = vqi
    _box(mon, Vector3(0, 1.8, -0.2), Vector3(1.0, 0.14, 0.36), wood2)
    _txt(mon, Vector3(0, 1.8, 0.0), WHO[i], 28, Color(0.95, 0.82, 0.5), 0.0)

    # lampe de banquier verte
    _cyl(pod, Vector3(-0.55, 0.85, -0.62), 0.1, 0.12, 0.05, brass)
    _cyl(pod, Vector3(-0.55, 1.05, -0.62), 0.016, 0.016, 0.38, brass)
    _box(pod, Vector3(-0.55, 1.25, -0.58), Vector3(0.36, 0.1, 0.2), _mat(Color(0.06, 0.26, 0.14), 0.3, 0.2))
    _box(pod, Vector3(-0.55, 1.18, -0.58), Vector3(0.3, 0.02, 0.16), _emit(Color(1.0, 0.86, 0.55), 2.6))
    var dl := OmniLight3D.new()
    dl.position = Vector3(-0.55, 1.1, -0.4)
    dl.omni_range = 4.0
    dl.light_energy = 1.5
    dl.light_color = Color(1.0, 0.84, 0.55)
    dl.light_volumetric_fog_energy = 0.2
    pod.add_child(dl)

    # clavier, buvard, papiers, bougie
    _box(pod, Vector3(-0.1, 0.83, 0.0), Vector3(1.0, 0.01, 0.42), _mat(Color(0.18, 0.10, 0.08), 0.9, 0.0))
    _box(pod, Vector3(-0.1, 0.86, -0.02), Vector3(0.66, 0.04, 0.24), dark)
    _box(pod, Vector3(-0.1, 0.885, -0.02), Vector3(0.6, 0.012, 0.19), _mat(Color(0.75, 0.72, 0.65), 0.6, 0.1))
    _box(pod, Vector3(0.42, 0.85, 0.02), Vector3(0.09, 0.035, 0.15), dark)
    for k in 4:
        _box(pod, Vector3(0.75 + randf() * 0.1, 0.835 + float(k) * 0.008, 0.0), Vector3(0.3, 0.008, 0.4), paper)
    _candle(pod, Vector3(-1.4, 0.83, -0.2), 0.24)

    # bouton rouge d'appel a DIEU
    _cyl(pod, Vector3(0.52, 0.84, -0.22), 0.13, 0.15, 0.06, brass)
    var redm := _emit(Color(0.85, 0.12, 0.1), 1.6)
    _cyl(pod, Vector3(0.52, 0.89, -0.22), 0.1, 0.11, 0.06, redm)
    _txt(pod, Vector3(0.52, 0.95, -0.36), Loc.t("red_btn"), 18, Color(0.95, 0.75, 0.5), 180.0)
    if i == MY_POD:
        red_mat = redm

    if i == MY_POD:
        # pile de papier a froisser (basket) + radio
        var pile := _box(pod, Vector3(1.55, 0.95, -0.35), Vector3(0.32, 0.22, 0.42), paper, true)
        pile.set_meta("kind", "paper")
        var rad := _box(pod, Vector3(-1.5, 0.98, -0.3), Vector3(0.42, 0.26, 0.2), _mat(Color(0.45, 0.25, 0.12), 0.6, 0.1), true)
        rad.set_meta("kind", "radio")
        _cyl(pod, Vector3(-1.62, 0.98, -0.41), 0.07, 0.07, 0.02, _mat(Color(0.15, 0.12, 0.1), 0.8, 0.2)).rotation_degrees.x = 90.0
        _box(pod, Vector3(-1.42, 1.02, -0.41), Vector3(0.14, 0.06, 0.01), _emit(Color(1.0, 0.7, 0.3), 1.5))
        _cyl(pod, Vector3(-1.32, 1.25, -0.25), 0.006, 0.006, 0.3, brass)
        radio_spot = Node3D.new()
        radio_spot.position = Vector3(-1.5, 1.0, -0.3)
        pod.add_child(radio_spot)
        radio_lbl = _txt(pod, Vector3(-1.5, 1.28, -0.3), "", 18, Color(1.0, 0.8, 0.45), 180.0)

    # telephone de laiton
    var pm := _emit(Color(0.95, 0.72, 0.35), 0.5)
    phone_mats.append(pm)
    var cons := _box(pod, Vector3(1.0, 0.88, -0.1), Vector3(0.5, 0.14, 0.42), dark, true)
    cons.set_meta("kind", "phone")
    cons.set_meta("idx", i)
    _box(pod, Vector3(1.0, 0.96, -0.22), Vector3(0.3, 0.035, 0.14), pm)
    _box(pod, Vector3(1.0, 1.02, 0.0), Vector3(0.17, 0.15, 0.36), brass)
    for k in 9:
        _cyl(pod, Vector3(0.87 + float(k % 3) * 0.13, 0.955, -0.12 + floor(float(k) / 3.0) * 0.08), 0.035, 0.035, 0.02, brass)

    # balise d'appel : flamme votive suspendue
    var bm := _emit(Color(0.4, 0.33, 0.25), 0.3)
    beam_mats.append(bm)
    _cyl(pod, Vector3(0, 2.5, -0.3), 0.02, 0.02, 1.2, brass)
    var tm := TorusMesh.new()
    tm.inner_radius = 0.22
    tm.outer_radius = 0.26
    tm.rings = 24
    var tmi := MeshInstance3D.new()
    tmi.mesh = tm
    tmi.material_override = brass
    tmi.position = Vector3(0, 2.0, -0.3)
    tmi.rotation_degrees = Vector3(90, 0, 0)
    pod.add_child(tmi)
    var lamp := MeshInstance3D.new()
    var lsp := SphereMesh.new()
    lsp.radius = 0.17
    lsp.height = 0.34
    lamp.mesh = lsp
    lamp.material_override = bm
    lamp.position = Vector3(0, 2.0, -0.3)
    pod.add_child(lamp)

    # separation BASSE, derriere le siege : on se voit tous
    _box(pod, Vector3(0, 0.52, 1.72), Vector3(2.6, 1.04, 0.1), wood2, true)
    _box(pod, Vector3(0, 1.07, 1.72), Vector3(2.66, 0.06, 0.15), brass)
    for sx in [-1.3, 1.3]:
        _cyl(pod, Vector3(sx, 1.18, 1.72), 0.05, 0.05, 0.18, brass)

    # chaise de bureau a cadre de laiton
    var cloth := _mat(Color(0.26, 0.09, 0.09), 0.75, 0.0)
    var seat := _box(pod, Vector3(0, 0.49, 0.78), Vector3(0.64, 0.12, 0.62), cloth, true)
    seat.set_meta("kind", "chair")
    seat.set_meta("idx", i)
    _box(pod, Vector3(0, 0.95, 1.08), Vector3(0.62, 0.8, 0.12), cloth)
    _box(pod, Vector3(0, 1.37, 1.07), Vector3(0.66, 0.08, 0.14), brass)
    for sx in [-0.36, 0.36]:
        _box(pod, Vector3(sx, 0.72, 0.79), Vector3(0.05, 0.3, 0.42), brass)
    _cyl(pod, Vector3(0, 0.25, 0.78), 0.05, 0.06, 0.48, brass)
    for k in 5:
        var ca := TAU * float(k) / 5.0
        var fo := _box(pod, Vector3(sin(ca) * 0.18, 0.06, 0.78 + cos(ca) * 0.18), Vector3(0.07, 0.05, 0.36), brass)
        fo.rotation.y = ca

    # tapis liturgique sous le poste
    _box(pod, Vector3(0, 0.014, 0.2), Vector3(3.4, 0.02, 3.0), _mat(Color(0.28, 0.08, 0.09), 0.95, 0.0))
    _box(pod, Vector3(0, 0.02, 0.2), Vector3(3.2, 0.01, 2.8), _mat(Color(0.35, 0.11, 0.11), 0.95, 0.0))


func _alcove() -> void:
    var a := TAU / float(PODS) * 0.5
    var hold := Node3D.new()
    hold.position = Vector3(sin(a) * (ROOM_R - 3.0), 0, cos(a) * (ROOM_R - 3.0))
    add_child(hold)
    hold.look_at(Vector3.ZERO, Vector3.UP)

    var wood := _wood()
    var wood2 := _wood(0.7)
    var brass := _gold(0.3)
    var dark := _mat(Color(0.07, 0.065, 0.06), 0.4, 0.4)
    var ivory := _mat(Color(0.86, 0.83, 0.76), 0.4, 0.05)

    # ---- chapelle du cafe : niche de pierre + comptoir de bois
    _box(hold, Vector3(-1.7, 2.1, 0.75), Vector3(3.6, 4.2, 0.4), _stone(0.65))
    for sx in [-1.0, 1.0]:
        var sp := _box(hold, Vector3(-1.7 + sx * 0.8, 4.5, 0.75), Vector3(0.22, 1.8, 0.4), _stone(0.65))
        sp.rotation_degrees = Vector3(0, 0, sx * 24.0)
    _box(hold, Vector3(-1.7, 0.46, 0.25), Vector3(3.2, 0.92, 0.8), wood2, true)
    _box(hold, Vector3(-1.7, 0.94, 0.25), Vector3(3.3, 0.06, 0.88), wood)
    _box(hold, Vector3(-1.7, 0.96, -0.17), Vector3(3.3, 0.04, 0.06), brass)
    _txt(hold, Vector3(-1.7, 3.5, 0.53), Loc.t("coffee_title"), 46, Color(0.95, 0.80, 0.45), 180.0)
    _txt(hold, Vector3(-1.7, 3.15, 0.53), Loc.t("coffee_sub"), 22, Color(0.75, 0.62, 0.42), 180.0)

    # ---- MACHINE A ESPRESSO RELIQUAIRE
    var mx := -1.7
    _cyl(hold, Vector3(mx, 1.02, 0.2), 0.62, 0.7, 0.16, brass)
    _cyl(hold, Vector3(mx, 1.42, 0.2), 0.56, 0.6, 0.66, ivory, true)
    _cyl(hold, Vector3(mx, 1.76, 0.2), 0.6, 0.6, 0.06, brass)
    _box(hold, Vector3(mx, 2.12, 0.3), Vector3(1.1, 0.68, 0.66), ivory)
    for sx in [-0.56, 0.56]:
        _box(hold, Vector3(mx + sx, 2.12, 0.3), Vector3(0.06, 0.72, 0.7), brass)
        var wing := _box(hold, Vector3(mx + sx * 1.35, 2.3, 0.42), Vector3(0.16, 0.8, 0.44), ivory)
        wing.rotation_degrees = Vector3(0, 0, sign(sx) * 10.0)
    _box(hold, Vector3(mx, 2.48, 0.3), Vector3(1.16, 0.07, 0.72), brass)

    # visage souriant
    var face := _box(hold, Vector3(mx, 2.14, -0.04), Vector3(0.92, 0.58, 0.06), dark, true)
    face.set_meta("kind", "coffee")
    _box(hold, Vector3(mx, 2.14, -0.02), Vector3(1.0, 0.66, 0.04), brass)
    for sx2 in [-0.21, 0.21]:
        for k in 5:
            var ea: float = -1.0 + float(k) * 0.5
            var ey := _box(hold, Vector3(mx + sx2 + sin(ea) * 0.075, 2.22 + cos(ea) * 0.04, -0.08),
                           Vector3(0.045, 0.045, 0.01), _emit(Color(1.0, 0.78, 0.35), 3.0))
            ey.rotation_degrees = Vector3(0, 0, rad_to_deg(ea))
    for k in 7:
        var sa: float = -1.1 + float(k) * 0.37
        _box(hold, Vector3(mx + sin(sa) * 0.22, 2.06 - cos(sa) * 0.08, -0.08), Vector3(0.045, 0.045, 0.01), _emit(Color(1.0, 0.78, 0.35), 3.0))

    # groupe, becs, tasse
    _cyl(hold, Vector3(mx, 1.72, 0.0), 0.16, 0.14, 0.12, brass)
    _cyl(hold, Vector3(mx, 1.62, 0.0), 0.1, 0.12, 0.1, brass)
    for sx3 in [-0.06, 0.0, 0.06]:
        _cyl(hold, Vector3(mx + sx3, 1.55, 0.0), 0.011, 0.016, 0.07, brass)
    _cyl(hold, Vector3(mx - 0.44, 1.68, 0.04), 0.02, 0.02, 0.36, brass)
    _cyl(hold, Vector3(mx - 0.44, 1.5, 0.04), 0.045, 0.028, 0.07, brass)
    _cyl(hold, Vector3(mx, 1.3, 0.0), 0.34, 0.34, 0.04, dark)
    _cyl(hold, Vector3(mx, 1.33, 0.0), 0.31, 0.31, 0.02, brass)
    _cyl(hold, Vector3(mx, 1.4, 0.0), 0.12, 0.095, 0.13, ivory)
    _cyl(hold, Vector3(mx, 1.47, 0.0), 0.125, 0.125, 0.012, brass)
    # panneau d'icones
    _box(hold, Vector3(mx + 0.62, 1.95, -0.02), Vector3(0.26, 0.8, 0.05), dark)
    _box(hold, Vector3(mx + 0.62, 1.95, -0.05), Vector3(0.3, 0.86, 0.02), brass)
    for k in 5:
        _cyl(hold, Vector3(mx + 0.62, 2.25 - float(k) * 0.15, -0.07), 0.05, 0.05, 0.01, _emit(Color(1.0, 0.78, 0.35), 2.2))

    # halo + bougies votives
    var ht := TorusMesh.new()
    ht.inner_radius = 0.48
    ht.outer_radius = 0.55
    ht.rings = 36
    var hmi := MeshInstance3D.new()
    hmi.mesh = ht
    hmi.material_override = _emit(Color(1.0, 0.82, 0.42), 2.8)
    hmi.position = Vector3(mx, 2.95, 0.25)
    hmi.rotation_degrees = Vector3(12, 0, 0)
    hold.add_child(hmi)
    _star(hold, Vector3(mx, 3.2, 0.25), 0.4, _emit(Color(1.0, 0.88, 0.55), 2.6), 180.0)
    for sx4 in [-1.15, 1.15]:
        _candle(hold, Vector3(mx + sx4, 0.97, -0.05), 0.3)
    var hl := OmniLight3D.new()
    hl.position = Vector3(mx, 2.6, -0.5)
    hl.omni_range = 6.0
    hl.light_energy = 0.8
    hl.light_color = Color(1.0, 0.76, 0.38)
    hold.add_child(hl)

    # vapeur
    var steam := GPUParticles3D.new()
    var spm := ParticleProcessMaterial.new()
    spm.direction = Vector3(0, 1, 0)
    spm.spread = 10.0
    spm.gravity = Vector3(0, 0.22, 0)
    spm.initial_velocity_min = 0.1
    spm.initial_velocity_max = 0.26
    spm.scale_min = 0.4
    spm.scale_max = 1.3
    spm.color = Color(1, 0.95, 0.85, 0.3)
    steam.process_material = spm
    var sq := QuadMesh.new()
    sq.size = Vector2(0.08, 0.08)
    var sdm := StandardMaterial3D.new()
    sdm.albedo_color = Color(1, 0.95, 0.88, 0.22)
    sdm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    sdm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    sdm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
    sq.material = sdm
    steam.draw_pass_1 = sq
    steam.amount = 18
    steam.lifetime = 2.4
    steam.position = Vector3(mx, 1.52, 0.0)
    hold.add_child(steam)

    # ---- DISTRIBUTRICE EN ARMOIRE D'EGLISE
    var vx := 2.1
    _box(hold, Vector3(vx, 1.15, 0.3), Vector3(1.5, 2.3, 0.8), wood2, true)
    _box(hold, Vector3(vx, 2.34, 0.3), Vector3(1.62, 0.14, 0.9), wood)
    _box(hold, Vector3(vx, 2.44, 0.3), Vector3(1.4, 0.08, 0.8), brass)
    for sx5 in [-0.6, 0.6]:
        var sp2 := _box(hold, Vector3(vx + sx5 * 0.8, 2.95, 0.3), Vector3(0.18, 1.1, 0.4), wood)
        sp2.rotation_degrees = Vector3(0, 0, sign(sx5) * 22.0)
    _star(hold, Vector3(vx, 3.3, 0.0), 0.34, brass, 180.0)
    var vm := _box(hold, Vector3(vx, 1.3, -0.12), Vector3(1.2, 1.9, 0.08), dark, true)
    vm.set_meta("kind", "vending")
    _box(hold, Vector3(vx, 1.3, -0.14), Vector3(1.26, 1.96, 0.04), brass)
    _box(hold, Vector3(vx, 1.3, -0.16), Vector3(1.1, 1.78, 0.02), _glass(Color(0.7, 0.8, 0.9, 0.16)))
    _txt(hold, Vector3(vx, 2.52, -0.2), Loc.t("vending"), 28, Color(0.95, 0.8, 0.45), 180.0)
    for r in 4:
        var sy: float = 0.75 + float(r) * 0.36
        _box(hold, Vector3(vx, sy, 0.06), Vector3(1.06, 0.03, 0.46), brass)
        for c in 4:
            var px: float = vx - 0.4 + float(c) * 0.27
            _box(hold, Vector3(px, sy + 0.15, 0.0), Vector3(0.19, 0.24, 0.1),
                 _mat(Color(randf_range(0.5, 0.95), randf_range(0.35, 0.8), randf_range(0.2, 0.5)), 0.6, 0.1))
            for k in 3:
                _cyl(hold, Vector3(px, sy + 0.15, 0.12 + float(k) * 0.09), 0.07, 0.07, 0.012, brass)
    var vl := OmniLight3D.new()
    vl.position = Vector3(vx, 1.45, -0.05)
    vl.omni_range = 2.6
    vl.light_energy = 0.7
    vl.light_color = Color(1.0, 0.86, 0.6)
    hold.add_child(vl)
    _box(hold, Vector3(vx, 0.4, -0.18), Vector3(0.95, 0.3, 0.06), dark)
    _box(hold, Vector3(vx, 0.58, -0.2), Vector3(1.0, 0.05, 0.05), brass)

    # ---- tronc a offrandes (decor)
    _box(hold, Vector3(3.6, 0.5, 0.2), Vector3(0.5, 1.0, 0.5), wood2, true)
    _box(hold, Vector3(3.6, 1.02, 0.2), Vector3(0.56, 0.06, 0.56), brass)
    _box(hold, Vector3(3.6, 1.06, 0.2), Vector3(0.22, 0.02, 0.05), dark)
    _txt(hold, Vector3(3.6, 0.72, -0.07), Loc.t("offer_box"), 20, Color(0.9, 0.78, 0.45), 180.0)

    # ---- interrupteur sur colonne
    _cyl(hold, Vector3(-3.9, 0.7, 0.2), 0.16, 0.2, 1.4, _stone(0.8), true)
    var sw := _box(hold, Vector3(-3.9, 1.5, 0.04), Vector3(0.26, 0.34, 0.08), wood, true)
    sw.set_meta("kind", "switch")
    _box(hold, Vector3(-3.9, 1.56, -0.01), Vector3(0.15, 0.13, 0.02), _emit(Color(1.0, 0.85, 0.5), 2.0))
    _txt(hold, Vector3(-3.9, 1.28, -0.01), Loc.t("switch"), 20, Color(0.9, 0.78, 0.45), 180.0)

    # ---- table de pause
    _box(hold, Vector3(-3.4, 0.74, -1.9), Vector3(1.8, 0.1, 0.9), wood, true)
    for sx6 in [-0.78, 0.78]:
        _box(hold, Vector3(-3.4 + sx6, 0.37, -1.9), Vector3(0.1, 0.74, 0.8), wood2)
    _candle(hold, Vector3(-3.4, 0.79, -1.9), 0.26)
    for k in 2:
        _box(hold, Vector3(-3.4 - 1.4 + float(k) * 2.8, 0.45, -1.9), Vector3(0.5, 0.1, 0.5), wood2, true)
        _box(hold, Vector3(-3.4 - 1.4 + float(k) * 2.8, 0.78, -2.15), Vector3(0.5, 0.65, 0.08), wood2)
    _plant_local(hold, Vector3(-2.0, 0, -0.6))


func _plant_local(par: Node, p: Vector3) -> void:
    _cyl(par, p + Vector3(0, 0.26, 0), 0.3, 0.22, 0.52, _gold(0.2))
    _cyl(par, p + Vector3(0, 0.53, 0), 0.27, 0.27, 0.05, _mat(Color(0.25, 0.18, 0.12), 0.9, 0.0))
    for k in 10:
        var a := float(k) * 0.65
        var mi := MeshInstance3D.new()
        var bm := BoxMesh.new()
        bm.size = Vector3(0.1, 0.85, 0.3)
        mi.mesh = bm
        mi.material_override = _mat(Color(0.30, 0.52, 0.26), 0.85, 0.0)
        mi.position = p + Vector3(sin(a) * 0.18, 0.9 + randf() * 0.3, cos(a) * 0.18)
        mi.rotation_degrees = Vector3(randf_range(-30, 30), rad_to_deg(a), randf_range(-30, 30))
        par.add_child(mi)


func _prop(pos: Vector3, size: Vector3, c: Color, mass := 0.5, label := "objet", cup := false) -> RigidBody3D:
    var rb := RigidBody3D.new()
    rb.position = pos
    rb.mass = mass
    rb.can_sleep = true
    rb.continuous_cd = false
    var mi := MeshInstance3D.new()
    if label == Loc.t("prop_ball"):
        var smsh := SphereMesh.new()
        smsh.radius = size.x * 0.5
        smsh.height = size.x
        smsh.radial_segments = 10
        smsh.rings = 6
        mi.mesh = smsh
        var cs3 := CollisionShape3D.new()
        var sh3 := SphereShape3D.new()
        sh3.radius = size.x * 0.5
        cs3.shape = sh3
        rb.add_child(cs3)
        rb.continuous_cd = true
    elif cup:
        var cmsh := CylinderMesh.new()
        cmsh.top_radius = size.x * 0.5
        cmsh.bottom_radius = size.x * 0.38
        cmsh.height = size.y
        cmsh.radial_segments = 20
        mi.mesh = cmsh
        var cs2 := CollisionShape3D.new()
        var sh2 := CylinderShape3D.new()
        sh2.radius = size.x * 0.5
        sh2.height = size.y
        cs2.shape = sh2
        rb.add_child(cs2)
        var lid := MeshInstance3D.new()
        var lm := CylinderMesh.new()
        lm.top_radius = size.x * 0.53
        lm.bottom_radius = size.x * 0.53
        lm.height = 0.018
        lid.mesh = lm
        lid.material_override = _mat(Color(0.12, 0.13, 0.16), 0.5, 0.2)
        lid.position = Vector3(0, size.y * 0.5, 0)
        rb.add_child(lid)
    else:
        var bm := BoxMesh.new()
        bm.size = size
        mi.mesh = bm
        var cs := CollisionShape3D.new()
        var sh := BoxShape3D.new()
        sh.size = size
        cs.shape = sh
        rb.add_child(cs)
    mi.material_override = _mat(c, 0.55, 0.2)
    rb.add_child(mi)
    rb.set_meta("kind", "prop")
    rb.set_meta("label", label)
    add_child(rb)
    if t > 0.5:
        _litter(rb)
    return rb


## Les objets apparus en jeu (cafes, balles, livraisons, poulets...) ne
## s'accumulent pas a l'infini : au-dela de MAX_LITTER, le plus vieux disparait.
const MAX_LITTER := 40
var litter: Array = []

func _litter(rb: RigidBody3D) -> void:
    litter.append(rb)
    var i := 0
    while litter.size() > MAX_LITTER and i < litter.size():
        var o = litter[i]
        if not is_instance_valid(o):
            litter.remove_at(i)
            continue
        var old: RigidBody3D = o
        if old == held or old.has_meta("busy") or old.has_meta("item"):
            i += 1
            continue
        litter.remove_at(i)
        old.set_meta("busy", true)
        old.freeze = true
        var tw := old.create_tween().set_parallel(true)
        for c in old.get_children():
            if c is MeshInstance3D:
                tw.tween_property(c, "scale", Vector3.ONE * 0.01, 0.4)
        tw.chain().tween_callback(old.queue_free)


func _clutter() -> void:
    for i in PODS:
        var p: Vector3 = pod_pos[i]
        var d := -p.normalized()
        var side := Vector3(d.z, 0.0, -d.x)
        if randf() < 0.85:
            _prop(p + d * 0.1 + side * randf_range(-0.8, 0.8) + Vector3(0, 0.95, 0),
                  Vector3(0.12, 0.15, 0.12), Color(0.85, 0.82, 0.76), 0.4, Loc.t("prop_cup"))
        if randf() < 0.6:
            _prop(p + d * 0.35 + side * randf_range(-0.9, 0.9) + Vector3(0, 0.92, 0),
                  Vector3(0.26, 0.03, 0.34), Color(0.80, 0.76, 0.66), 0.25, Loc.t("prop_folder"))
    # quelques dossiers empiles sur les bancs, rien au milieu du passage
    for k in 3:
        var a := TAU * (float(k) + 0.33) / 3.0
        var r := ROOM_R - 5.6
        _prop(Vector3(sin(a) * r, 0.62, cos(a) * r), Vector3(0.3, 0.06, 0.36),
              Color(0.78, 0.74, 0.64), 0.3, Loc.t("prop_pile"))


# ------------------------------------------------------------- decor supplementaire

var led_mats := []
var bin_area: Area3D


func _decor() -> void:
    # tapis rouge circulaire autour de l'autel + allees vers chaque poste
    var red := _mat(Color(0.32, 0.05, 0.06), 0.95, 0.0)
    var trim := _gold(0.35)
    var segs := 40
    for i in segs:
        var a := TAU * float(i) / float(segs)
        var w := TAU * 6.4 / float(segs) + 0.05
        var c := _box(self, Vector3(sin(a) * 6.4, 0.012, cos(a) * 6.4), Vector3(w, 0.02, 1.5), red)
        c.rotation.y = a
        for rr in [5.62, 7.18]:
            var tr := _box(self, Vector3(sin(a) * rr, 0.024, cos(a) * rr), Vector3(TAU * rr / float(segs) + 0.04, 0.012, 0.06), trim)
            tr.rotation.y = a
    for i in PODS:
        var a := TAU * float(i) / float(PODS)
        var run := _box(self, Vector3(sin(a) * 8.0, 0.011, cos(a) * 8.0), Vector3(1.1, 0.02, 1.8), red)
        run.rotation.y = a

    # baies de serveurs de la simulation, LED qui clignotent
    for k in 4:
        var a := TAU * (float(k) + 0.25) / 4.0 + 0.2
        var hold := Node3D.new()
        hold.position = Vector3(sin(a) * (ROOM_R - 2.4), 0, cos(a) * (ROOM_R - 2.4))
        add_child(hold)
        hold.look_at(Vector3(0, 0, 0), Vector3.UP)
        for r in 2:
            var x := (float(r) - 0.5) * 0.95
            _box(hold, Vector3(x, 1.25, 0), Vector3(0.85, 2.5, 0.8), _mat(Color(0.06, 0.06, 0.07), 0.4, 0.6), true)
            _box(hold, Vector3(x, 1.25, -0.41), Vector3(0.75, 2.35, 0.02), _mat(Color(0.1, 0.1, 0.11), 0.3, 0.5))
            for row in 14:
                for col in 6:
                    var lm := _emit(Color(0.2, 1.0, 0.4) if randf() < 0.7 else Color(1.0, 0.5, 0.1), 2.5)
                    _box(hold, Vector3(x - 0.28 + float(col) * 0.06, 0.3 + float(row) * 0.15, -0.425), Vector3(0.025, 0.025, 0.01), lm)
                    if randf() < 0.35:
                        led_mats.append([lm, randf() * 10.0, randf_range(1.0, 7.0)])
            _txt(hold, Vector3(x, 2.62, -0.42), "SIM-0%d" % (k * 2 + r + 1), 20, Color(0.6, 1.0, 0.7), 180.0)
        var sl := OmniLight3D.new()
        sl.position = Vector3(0, 1.4, -0.8)
        sl.omni_range = 3.0
        sl.light_energy = 0.6
        sl.light_color = Color(0.4, 1.0, 0.6)
        hold.add_child(sl)

    # plantes de bureau un peu partout
    for k in 6:
        var a := TAU * (float(k) + 0.5) / 6.0 + 0.12
        _plant(Vector3(sin(a) * 12.2, 0, cos(a) * 12.2))

    # fontaine a eau benite
    var wa := TAU / float(PODS) * 0.5 + 0.42
    var wp := Vector3(sin(wa) * (ROOM_R - 3.2), 0, cos(wa) * (ROOM_R - 3.2))
    _box(self, wp + Vector3(0, 0.5, 0), Vector3(0.4, 1.0, 0.4), _mat(Color(0.85, 0.85, 0.88), 0.4, 0.1), true)
    var jug := _cyl(self, wp + Vector3(0, 1.28, 0), 0.17, 0.17, 0.55, _glass(Color(0.5, 0.75, 1.0, 0.45)))
    jug.set_meta("kind", "water")
    _txt(self, wp + Vector3(0, 1.75, 0), Loc.t("holy_water"), 22, Color(0.6, 0.85, 1.0), 0.0, true)

    # poubelle pres de ton poste (pour le basket de papier)
    var mp: Vector3 = pod_pos[MY_POD]
    var side := Vector3(-mp.z, 0, mp.x).normalized()
    var bp := mp + side * 2.4 + mp.normalized() * 0.4
    var bin := _cyl(self, bp + Vector3(0, 0.3, 0), 0.24, 0.2, 0.6, _mat(Color(0.25, 0.27, 0.3), 0.4, 0.6))
    _cyl(self, bp + Vector3(0, 0.58, 0), 0.22, 0.22, 0.02, _mat(Color(0.03, 0.03, 0.03), 0.9, 0.0))
    var ring := TorusMesh.new()
    ring.inner_radius = 0.22
    ring.outer_radius = 0.26
    var rmi := MeshInstance3D.new()
    rmi.mesh = ring
    rmi.material_override = _mat(Color(0.35, 0.37, 0.4), 0.3, 0.8)
    rmi.position = bp + Vector3(0, 0.6, 0)
    add_child(rmi)
    _txt(self, bp + Vector3(0, 0.95, 0), Loc.t("bin_label"), 20, Color(1.0, 0.75, 0.4), 0.0, true)
    bin_area = Area3D.new()
    var cs := CollisionShape3D.new()
    var sh := CylinderShape3D.new()
    sh.radius = 0.2
    sh.height = 0.3
    cs.shape = sh
    bin_area.add_child(cs)
    add_child(bin_area)
    bin_area.global_position = bp + Vector3(0, 0.35, 0)
    bin_area.body_entered.connect(_on_bin)
    bin.set_meta("kind", "bin")


func _plant(p: Vector3) -> void:
    _cyl(self, p + Vector3(0, 0.3, 0), 0.32, 0.24, 0.6, _mat(Color(0.55, 0.3, 0.2), 0.8, 0.0), true)
    _cyl(self, p + Vector3(0, 0.6, 0), 0.3, 0.3, 0.03, _mat(Color(0.18, 0.12, 0.08), 0.95, 0.0))
    var leaf := _mat(Color(0.16, 0.42, 0.18), 0.8, 0.0)
    var leaf2 := _mat(Color(0.24, 0.55, 0.22), 0.8, 0.0)
    for k in 11:
        var a := float(k) * 2.4
        var hgt := randf_range(0.6, 1.3)
        var mi := MeshInstance3D.new()
        var sm := SphereMesh.new()
        sm.radius = 0.12
        sm.height = 0.24
        mi.mesh = sm
        mi.material_override = leaf if k % 2 == 0 else leaf2
        mi.scale = Vector3(0.45, hgt * 3.2, 1.0)
        mi.position = p + Vector3(sin(a) * 0.14, 0.62 + hgt * 0.38, cos(a) * 0.14)
        mi.rotation = Vector3(sin(a) * 0.45, a, cos(a) * 0.45)
        add_child(mi)


func _on_bin(body: Node) -> void:
    if body is RigidBody3D and body.has_meta("kind") and str(body.get_meta("kind")) == "prop":
        if body == held:
            return
        hoops += 1
        _stat("hoops")
        Profile.count("hoops")
        viral.highlight("hoops")
        _money(5)
        Sfx.play("score", -4.0)
        _say(Loc.f("hoop", [hoops]), 2.5)
        var b: RigidBody3D = body
        b.set_meta("kind", "scored")
        get_tree().create_timer(1.5).timeout.connect(b.queue_free)


func _radio_next() -> void:
    var stations := ["", "radio_lounge", "radio_organ", "radio_chip"]
    radio_i = (radio_i + 1) % stations.size()
    Sfx.play("ui_click", -4.0, 0.6)
    if radio_i == 0:
        Sfx.stop("radio")
        radio_lbl.text = ""
        _say(Loc.t("radio_off"), 2.0)
        return
    var rp := Sfx.loop_at("radio", stations[radio_i], radio_spot, -6.0)
    if rp != null:
        rp.bus = "Music"
    var names := Loc.list("radio_names")
    radio_lbl.text = str(names[radio_i - 1])
    _say(Loc.t("radio_on") + str(names[radio_i - 1]), 3.0)


func _talk_to(i: int) -> void:
    for d in npcs:
        var dd: Dictionary = d
        if str(dd["name"]) == WHO[i]:
            var c = dd["char"]
            var line := Loc.pick("cw_talk")
            if randf() < 0.3:
                line = Loc.pick("cw_tips")
            var bub: Label3D = dd["bub"]
            bub.text = line
            dd["say"] = 6.0
            c.look_target = player
            c.typing = false
            c.say(3.0)
            c.set_emotion(["happy", "neutral", "worried"][randi() % 3])
            dd["t"] = 0.5
            return


# ------------------------------------------------------------- optimisation

## Passe « RV There Yet? » : tout le decor devient mat et doux (pas de plastique
## brillant ni de metal miroir), comme de la peinture satinee.
var _matte_done := {}

func _rv_matte(n: Node) -> void:
    for c in n.get_children():
        if c is MeshInstance3D:
            var mi: MeshInstance3D = c
            var mats: Array = [mi.material_override]
            if mi.mesh != null:
                for i in mi.mesh.get_surface_count():
                    mats.append(mi.get_active_material(i))
            for m in mats:
                if m is StandardMaterial3D and not _matte_done.has(m.get_instance_id()):
                    _matte_done[m.get_instance_id()] = true
                    var sm: StandardMaterial3D = m
                    if sm.shading_mode == BaseMaterial3D.SHADING_MODE_UNSHADED:
                        continue
                    var glassy := sm.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED
                    if not glassy:
                        sm.roughness = maxf(sm.roughness, 0.62 if sm.metallic > 0.5 else 0.78)
                        sm.metallic = sm.metallic * 0.55
                        sm.metallic_specular = 0.35
                    sm.rim_enabled = false
                    # couleurs plus chaudes et plus douces (moins de noir pur)
                    var a := sm.albedo_color
                    sm.albedo_color = Color(lerpf(a.r, 0.5, 0.08) * 1.04, lerpf(a.g, 0.42, 0.08), lerpf(a.b, 0.32, 0.08) * 0.96, a.a)
        if c.get_child_count() > 0 and not (c.get_script() == Character):
            _rv_matte(c)


func _merge_static() -> void:
    # Le decor est fait de milliers de petites pieces : on fusionne tout ce qui
    # ne bouge pas (par materiau) pour diviser les appels de rendu.
    var dyn := {}
    for m in strip_mats + gauge_mats + beam_mats + phone_mats + screen_mats:
        dyn[m] = true
    for e in led_mats:
        dyn[e[0]] = true
    if red_mat != null:
        dyn[red_mat] = true
    if core_mat != null:
        dyn[core_mat] = true
    var skip := {}
    for n in [player, core, halo, earth, ring_spot]:
        if n != null:
            skip[n] = true
    for d in npcs:
        skip[d["hold"]] = true
    var groups := {}
    var mats := {}
    var stack: Array = [self]
    var count := 0
    while not stack.is_empty():
        var n: Node = stack.pop_back()
        if skip.has(n):
            continue
        for c in n.get_children():
            stack.append(c)
        if not (n is MeshInstance3D):
            continue
        var mi := n as MeshInstance3D
        if not mi.visible or mi.mesh == null or not (mi.mesh is PrimitiveMesh):
            continue
        var m := mi.material_override as StandardMaterial3D
        if m == null or dyn.has(m) or m.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
            continue
        if m.billboard_mode != BaseMaterial3D.BILLBOARD_DISABLED:
            continue
        var ac := m.albedo_color
        var q := 16.0
        var key := "%d,%d,%d|%s|%d,%d,%d|%.1f|%.1f|%.1f|%s|%s|%s" % [int(ac.r * q), int(ac.g * q), int(ac.b * q),
            m.emission_enabled, int(m.emission.r * q), int(m.emission.g * q), int(m.emission.b * q),
            m.emission_energy_multiplier, m.roughness, m.metallic, m.albedo_texture, m.normal_texture, m.shading_mode]
        if not groups.has(key):
            var st := SurfaceTool.new()
            st.begin(Mesh.PRIMITIVE_TRIANGLES)
            groups[key] = st
            mats[key] = m
        var xf := global_transform.affine_inverse() * mi.global_transform
        (groups[key] as SurfaceTool).append_from(mi.mesh, 0, xf)
        mi.visible = false
        count += 1
    for key in groups:
        var st: SurfaceTool = groups[key]
        var merged := MeshInstance3D.new()
        merged.mesh = st.commit()
        merged.material_override = mats[key]
        add_child(merged)
    print("Decor fusionne : ", count, " pieces -> ", groups.size(), " maillages")


func _tick_leds(dt: float) -> void:
    for e in led_mats:
        var m: StandardMaterial3D = e[0]
        e[1] = float(e[1]) + dt * float(e[2])
        m.emission_energy_multiplier = 2.5 if fmod(float(e[1]), 2.0) < 1.0 else 0.2


## Quel employe occupe ce poste (jamais le meme que le mien, jamais Ziggy : c'est le stagiaire).
func _npc_preset(pod_i: int) -> String:
    var mine := str(Profile.my_look().get("preset", ""))
    var pool: Array = []
    for id in Character.PRESET_ORDER:
        if id != "ziggy" and id != mine:
            pool.append(id)
    return str(pool[pod_i % pool.size()])


func _npc(pod_i: int) -> void:
    var hold := Node3D.new()
    hold.position = seat_pos[pod_i]
    add_child(hold)
    hold.rotation.y = float(pod_yaw[pod_i])
    var rng := RandomNumberGenerator.new()
    rng.seed = 1000 + pod_i * 77
    # les collegues sont les employes des planches (Ted, Nova, Benoit...)
    var lk := Character.preset(_npc_preset(pod_i))
    lk["headset"] = true
    var c := Character.new()
    hold.add_child(c)
    c.typing = true
    c.build(lk, "sit")
    c.position = Vector3(0, 0.6, -0.1)
    c.anim_speed = rng.randf_range(0.85, 1.15)
    var bub := _txt(hold, Vector3(0, 2.05, 0.0), "", 30, Color(1.0, 0.95, 0.8), 0.0, true)
    bub.width = 900
    bub.outline_size = 10
    bub.outline_modulate = Color(0, 0, 0, 0.85)
    bub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    Sfx.loop_at("type%d" % pod_i, "typing", hold, -16.0, randf() * 7.0)
    npcs.append({"hold": hold, "char": c, "bub": bub, "t": randf() * 10.0, "say": 0.0, "name": WHO[pod_i],
        "pod": pod_i, "look": lk, "state": "desk", "path": [], "wait": 0.0, "step": 0.0})


func _polar(a: float, r: float) -> Vector3:
    return Vector3(sin(a) * r, 0, cos(a) * r)


func _ring_path(a0: float, a1: float, r: float) -> Array:
    var out := []
    var da := wrapf(a1 - a0, -PI, PI)
    var n := int(ceil(abs(da) / 0.25))
    for k in range(1, n + 1):
        out.append(_polar(a0 + da * float(k) / float(n), r))
    return out


func _npc_go(dd: Dictionary) -> void:
    # un collegue se leve : cafe pour Dieu ou eau benite
    var i: int = int(dd["pod"])
    var pa := TAU * float(i) / float(PODS)
    var gap := pa + TAU / float(PODS) * 0.5
    var path := []
    path.append(_polar(pa + 0.06, 11.2))
    path.append(_polar(gap, 11.4))
    var to_coffee := randf() < 0.6
    if to_coffee:
        var ca := TAU * 4.5 / 8.0
        path.append(_polar(gap, 7.9))
        path += _ring_path(gap, ca, 7.9)
        dd["goal"] = "coffee"
    else:
        var wa := TAU / float(PODS) * 0.5 + 0.42
        path.append(_polar(gap, 13.0))
        path += _ring_path(gap, wa, 13.0)
        path.append(_polar(wa, 13.4))
        dd["goal"] = "water"
    var back := path.duplicate()
    back.reverse()
    back.append(seat_pos[i])
    dd["path"] = path
    dd["back"] = back
    dd["state"] = "out"
    var c = dd["char"]
    var lk: Dictionary = dd["look"]
    c.typing = false
    c.build(lk, "stand")
    c.position = Vector3(0, 0.78 * float(lk.get("height", 1.0)), 0)
    c.walking = true
    Sfx.stop("type%d" % i)


func _npc_walk(dd: Dictionary, dt: float) -> void:
    var hold: Node3D = dd["hold"]
    var c = dd["char"]
    var path: Array = dd["path"]
    if str(dd["state"]) == "wait":
        dd["wait"] = float(dd["wait"]) - dt
        if float(dd["wait"]) <= 0.0:
            dd["state"] = "back"
            dd["path"] = dd["back"]
            c.walking = true
        return
    if path.is_empty():
        if str(dd["state"]) == "out":
            dd["state"] = "wait"
            dd["wait"] = randf_range(3.0, 6.0)
            c.walking = false
            var bub: Label3D = dd["bub"]
            bub.text = Loc.pick("cw_coffee" if str(dd["goal"]) == "coffee" else "cw_water")
            dd["say"] = 4.0
            c.say(2.0)
            c.set_emotion("happy")
        else:
            # retour au poste
            var i: int = int(dd["pod"])
            dd["state"] = "desk"
            hold.position = seat_pos[i]
            hold.rotation.y = float(pod_yaw[i])
            c.walking = false
            c.typing = true
            c.build(dd["look"], "sit")
            c.position = Vector3(0, 0.6, -0.1)
            if cushions.has(i):
                _fart_at(i, false)
            Sfx.loop_at("type%d" % i, "typing", hold, -16.0, randf() * 7.0)
        return
    var target: Vector3 = path[0]
    var cur := hold.position
    var to := Vector3(target.x - cur.x, 0, target.z - cur.z)
    var dist := to.length()
    var spd := 1.3 * dt
    if dist <= spd:
        hold.position = Vector3(target.x, 0, target.z)
        path.pop_front()
    else:
        var dir := to / dist
        hold.position += dir * spd
        var want := atan2(-dir.x, -dir.z)
        hold.rotation.y = lerp_angle(hold.rotation.y, want, clamp(dt * 8.0, 0.0, 1.0))
    dd["step"] = float(dd["step"]) + dt
    if float(dd["step"]) > 0.45:
        dd["step"] = 0.0
        Sfx.play_at("step%d" % (randi() % 4), hold.global_position, -18.0)


func _npcs(dt: float) -> void:
    npc_t += dt
    var walking := false
    for d in npcs:
        if str(d["state"]) != "desk":
            walking = true
    if not frozen and not walking and npc_t > 20.0 and randf() < dt * 0.04:
        npc_t = 0.0
        var cand: Dictionary = npcs[randi() % npcs.size()]
        if float(cand["say"]) <= 0.0:
            _npc_go(cand)
    for d in npcs:
        var dd: Dictionary = d
        dd["t"] = float(dd["t"]) + dt
        var tt: float = float(dd["t"])
        var c = dd["char"]
        if str(dd["state"]) != "desk":
            _npc_walk(dd, dt)
            c.look_target = player if (player != null and str(dd["state"]) == "wait") else null
            var bub2: Label3D = dd["bub"]
            if float(dd["say"]) > 0.0:
                dd["say"] = float(dd["say"]) - dt
                if float(dd["say"]) <= 0.0:
                    bub2.text = ""
            continue
        # regarde le joueur de temps en temps, sinon son ecran
        if fposmod(tt, 13.0) < 3.0 and player != null:
            c.look_target = player
            c.typing = false
        else:
            c.look_target = null
            c.look_point = Vector3.ZERO
            c.typing = true
        var bub: Label3D = dd["bub"]
        var pi_: int = int(dd["pod"])
        # collegue au telephone avec son propre fidele
        if npc_calls.has(pi_):
            npc_calls[pi_] = float(npc_calls[pi_]) - dt
            if randf() < dt * 0.5:
                c.say(randf_range(0.8, 2.2))
                c.typing = false
                c.look_target = null
            if float(npc_calls[pi_]) <= 0.0:
                npc_calls.erase(pi_)
                if randf() < 0.7:
                    bub.text = Loc.pick("cw_win")
                    c.set_emotion("laugh")
                    c.emote(["flex", "dance", "laugh"][randi() % 3])
                else:
                    bub.text = Loc.pick("cw_fail")
                    c.set_emotion(["cry", "fury"][randi() % 2])
                dd["say"] = 4.0
        elif not frozen and randf() < dt * 0.012:
            npc_calls[pi_] = randf_range(15.0, 35.0)
            Sfx.play_at("call_connect", (dd["hold"] as Node3D).global_position, -14.0)
        if float(dd["say"]) > 0.0:
            dd["say"] = float(dd["say"]) - dt
            if float(dd["say"]) <= 0.0:
                bub.text = ""
                c.set_emotion("neutral")
        elif randf() < dt * 0.035:
            bub.text = NPC_LINES[randi() % NPC_LINES.size()]
            dd["say"] = 5.0
            c.say(2.5)
            c.set_emotion(["happy", "worried", "angry", "neutral", "shock"][randi() % 5])


func _player() -> void:
    player = CharacterBody3D.new()
    var cs := CollisionShape3D.new()
    var cap := CapsuleShape3D.new()
    cap.radius = 0.35
    cap.height = 1.8
    cs.shape = cap
    player.add_child(cs)
    cam = Camera3D.new()
    cam.position = Vector3(0, 0.72, 0)
    cam.fov = Loc.fov
    Loc.settings_changed.connect(func(): cam.fov = Loc.fov)
    cam.current = true
    player.add_child(cam)
    ray = RayCast3D.new()
    ray.target_position = Vector3(0, 0, -3.5)
    ray.enabled = true
    cam.add_child(ray)
    hold_point = Node3D.new()
    hold_point.position = Vector3(0.4, -0.22, -1.0)
    cam.add_child(hold_point)
    flashlight = SpotLight3D.new()
    flashlight.position = Vector3(0.18, -0.12, 0.0)
    flashlight.spot_range = 16.0
    flashlight.spot_angle = 26.0
    flashlight.spot_attenuation = 0.8
    flashlight.light_energy = 0.0
    flashlight.light_color = Color(1.0, 0.93, 0.8)
    flashlight.light_volumetric_fog_energy = 0.7
    flashlight.shadow_enabled = Loc.quality >= 1
    cam.add_child(flashlight)
    add_child(player)
    ray.add_exception(player)
    _outline_pass()
    fp_hands = FpHands.new()
    fp_hands.main = self
    cam.add_child(fp_hands)
    # on commence debout a cote de son poste, face au centre
    var mp: Vector3 = pod_pos[MY_POD]
    var side := Vector3(-mp.z, 0, mp.x).normalized()
    player.global_position = mp - side * 2.1 + mp.normalized() * 0.2 + Vector3(0, 1.0, 0)
    player.look_at(mp * 0.72 + side * 0.8 + Vector3(0, 1.0, 0), Vector3.UP)
    stand_pos = player.global_position


# ------------------------------------------------------------- interface

func _lbl(par: Node, size: int, col: Color) -> Label:
    var l := Label.new()
    l.add_theme_font_size_override("font_size", size)
    l.add_theme_color_override("font_color", col)
    l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    par.add_child(l)
    return l


func _style(bg: Color, border: Color) -> StyleBoxFlat:
    var sb := StyleBoxFlat.new()
    sb.bg_color = bg
    sb.border_color = border
    sb.set_border_width_all(2)
    sb.set_corner_radius_all(2)
    sb.set_content_margin_all(8)
    return sb


func _btn(par: Node, text: String) -> Button:
    var b := Button.new()
    b.text = text
    b.custom_minimum_size = Vector2(0, 36)
    b.focus_mode = Control.FOCUS_NONE
    b.add_theme_font_override("font", Loc.font("bold"))
    b.add_theme_font_size_override("font_size", 15)
    b.add_theme_color_override("font_color", Color(1.0, 0.7, 0.35))
    b.add_theme_color_override("font_hover_color", Color(0.06, 0.03, 0.01))
    b.add_theme_color_override("font_pressed_color", Color(0.06, 0.03, 0.01))
    b.add_theme_color_override("font_disabled_color", Color(0.38, 0.22, 0.1))
    b.add_theme_stylebox_override("normal", _style(Color(0.08, 0.045, 0.02, 0.95), Color(0.85, 0.45, 0.15)))
    b.add_theme_stylebox_override("hover", _style(Color(1.0, 0.6, 0.2), Color(1.0, 0.8, 0.5)))
    b.add_theme_stylebox_override("pressed", _style(Color(1.0, 0.85, 0.6), Color(1, 1, 1)))
    b.add_theme_stylebox_override("disabled", _style(Color(0.04, 0.025, 0.015, 0.9), Color(0.3, 0.16, 0.06)))
    b.mouse_entered.connect(Sfx.play.bind("ui_hover", -12.0, 1.0))
    b.pressed.connect(Sfx.play.bind("ui_click", -8.0, 1.0))
    par.add_child(b)
    return b


func _outline_pass() -> void:
    # contours noirs facon Lethal Company (quad plein ecran colle a la camera)
    var q := MeshInstance3D.new()
    var qm := QuadMesh.new()
    qm.size = Vector2(2, 2)
    q.mesh = qm
    q.extra_cull_margin = 16384.0
    q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    var om := ShaderMaterial.new()
    om.shader = load("res://shaders/outline.gdshader")
    om.render_priority = -100
    q.material_override = om
    cam.add_child(q)
    outline_node = q
    q.visible = false     # style « RV There Yet? » : pas de contours noirs


func _flbl(par: Node, fk: String, size: int, col: Color) -> Label:
    var l := Label.new()
    l.add_theme_font_override("font", Loc.font(fk))
    l.add_theme_font_size_override("font_size", size)
    l.add_theme_color_override("font_color", col)
    l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
    l.add_theme_constant_override("shadow_offset_x", 2)
    l.add_theme_constant_override("shadow_offset_y", 2)
    l.mouse_filter = Control.MOUSE_FILTER_IGNORE
    par.add_child(l)
    return l


func _hud() -> void:
    var cl := CanvasLayer.new()
    cl.layer = 6
    add_child(cl)
    hud_layer = cl

    vignette = ColorRect.new()
    vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
    vignette.color = Color(0.85, 0.08, 0.12, 0.0)
    vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
    cl.add_child(vignette)

    var orange := Color(1.0, 0.58, 0.18)
    # haut gauche : jour + heure, humeur
    hud_top = _flbl(cl, "title", 34, orange)
    hud_top.position = Vector2(28, 14)
    hud_mood = _flbl(cl, "mono", 16, Color(0.85, 0.62, 0.4))
    hud_mood.position = Vector2(30, 62)
    # haut centre : quota
    hud_quota = _flbl(cl, "title", 28, Color(1.0, 0.86, 0.6))
    hud_quota.anchor_left = 0.5
    hud_quota.anchor_right = 0.5
    hud_quota.offset_left = -300
    hud_quota.offset_right = 300
    hud_quota.offset_top = 16
    hud_quota.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    # haut droite : argent, exposition, avertissements
    hud_money = _flbl(cl, "title", 32, Color(0.6, 1.0, 0.62))
    hud_money.anchor_left = 1.0
    hud_money.anchor_right = 1.0
    hud_money.offset_left = -420
    hud_money.offset_right = -28
    hud_money.offset_top = 12
    hud_money.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    var el := _flbl(cl, "mono", 14, Color(0.85, 0.62, 0.4))
    el.text = Loc.t("hud_expo")
    el.anchor_left = 1.0
    el.anchor_right = 1.0
    el.offset_left = -420
    el.offset_right = -268
    el.offset_top = 64
    hud_expo = ProgressBar.new()
    hud_expo.show_percentage = false
    hud_expo.min_value = 0
    hud_expo.max_value = 100
    hud_expo.anchor_left = 1.0
    hud_expo.anchor_right = 1.0
    hud_expo.offset_left = -262
    hud_expo.offset_right = -28
    hud_expo.offset_top = 66
    hud_expo.offset_bottom = 82
    var bg := StyleBoxFlat.new()
    bg.bg_color = Color(0.05, 0.03, 0.02, 0.8)
    bg.border_color = orange
    bg.set_border_width_all(1)
    var fg := StyleBoxFlat.new()
    fg.bg_color = Color(1.0, 0.35, 0.2)
    hud_expo.add_theme_stylebox_override("background", bg)
    hud_expo.add_theme_stylebox_override("fill", fg)
    hud_expo.mouse_filter = Control.MOUSE_FILTER_IGNORE
    cl.add_child(hud_expo)
    hud_strikes = _flbl(cl, "mono", 15, Color(1.0, 0.4, 0.3))
    hud_strikes.anchor_left = 1.0
    hud_strikes.anchor_right = 1.0
    hud_strikes.offset_left = -420
    hud_strikes.offset_right = -28
    hud_strikes.offset_top = 88
    hud_strikes.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

    hud_obj = _flbl(cl, "bold", 17, Color(1.0, 0.9, 0.6))
    hud_obj.anchor_left = 0.5
    hud_obj.anchor_right = 0.5
    hud_obj.offset_left = -400
    hud_obj.offset_right = 400
    hud_obj.offset_top = 108
    hud_obj.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

    hud_mic = _flbl(cl, "bold", 18, Color(0.5, 1.0, 0.55))
    hud_mic.anchor_top = 1.0
    hud_mic.anchor_bottom = 1.0
    hud_mic.offset_left = 28
    hud_mic.offset_top = -46
    hud_mic.visible = false

    hud_rule = _flbl(cl, "mono", 18, C_AMBER)
    hud_rule.anchor_left = 1.0
    hud_rule.anchor_right = 1.0
    hud_rule.offset_left = -470
    hud_rule.offset_right = -28
    hud_rule.offset_top = 120
    hud_rule.offset_bottom = 300
    hud_rule.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    hud_rule.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

    crosshair = _flbl(cl, "mono", 20, Color(1.0, 0.9, 0.75, 0.8))
    crosshair.set_anchors_preset(Control.PRESET_CENTER)
    crosshair.offset_left = -10
    crosshair.offset_right = 10
    crosshair.offset_top = -14
    crosshair.offset_bottom = 14
    crosshair.text = "·"
    crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

    hud_prompt = _flbl(cl, "bold", 20, Color(1.0, 0.92, 0.78))
    hud_prompt.set_anchors_preset(Control.PRESET_CENTER)
    hud_prompt.offset_left = -360
    hud_prompt.offset_right = 360
    hud_prompt.offset_top = 30
    hud_prompt.offset_bottom = 70
    hud_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

    hud_main = _flbl(cl, "mono", 22, Color(1.0, 0.95, 0.85))
    hud_main.anchor_left = 0.5
    hud_main.anchor_right = 0.5
    hud_main.anchor_top = 1.0
    hud_main.anchor_bottom = 1.0
    hud_main.offset_left = -560
    hud_main.offset_right = 560
    hud_main.offset_top = -120
    hud_main.offset_bottom = -34
    hud_main.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    hud_main.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hud_main.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM

    _build_pc(cl)
    _build_coffee(cl)


func _build_pc(cl: CanvasLayer) -> void:
    var orange := Color(1.0, 0.58, 0.18)
    var pc := PanelContainer.new()
    pc.add_theme_stylebox_override("panel", _style(Color(0.025, 0.015, 0.01, 0.97), orange))
    pc.anchor_left = 0.5
    pc.anchor_right = 0.5
    pc.anchor_top = 0.5
    pc.anchor_bottom = 0.5
    pc.offset_left = -720
    pc.offset_right = 720
    pc.offset_top = -380
    pc.offset_bottom = 400
    pc.visible = false
    cl.add_child(pc)
    pc_ui = pc

    var row := HBoxContainer.new()
    row.add_theme_constant_override("separation", 18)
    pc.add_child(row)

    # ---- colonne gauche : appel video
    var left := VBoxContainer.new()
    left.add_theme_constant_override("separation", 8)
    left.custom_minimum_size = Vector2(600, 0)
    row.add_child(left)
    pc_video_head = _flbl(left, "term", 30, orange)
    var frame := PanelContainer.new()
    frame.add_theme_stylebox_override("panel", _style(Color(0, 0, 0), Color(0.5, 0.28, 0.1)))
    left.add_child(frame)
    callview = CallView.new()
    add_child(callview)
    pc_video = TextureRect.new()
    pc_video.texture = callview.get_texture()
    if my_video_quad != null:
        var vm := StandardMaterial3D.new()
        vm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
        vm.albedo_texture = callview.get_texture()
        vm.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
        my_video_quad.material_override = vm
    pc_video.custom_minimum_size = Vector2(584, 438)
    pc_video.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    pc_video.stretch_mode = TextureRect.STRETCH_SCALE
    pc_video.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    var wm := ShaderMaterial.new()
    wm.shader = load("res://shaders/webcam.gdshader")
    pc_video.material = wm
    frame.add_child(pc_video)
    # mini-jeu (par-dessus la video, entre deux appels)
    minigame = MiniGame.new()
    frame.add_child(minigame)
    minigame.finished.connect(_on_minigame_done)
    # incrustations sur la video
    var ov := Control.new()
    ov.mouse_filter = Control.MOUSE_FILTER_IGNORE
    frame.add_child(ov)
    pc_rec = _flbl(ov, "term", 26, Color(1.0, 0.25, 0.2))
    pc_rec.position = Vector2(14, 8)
    pc_sig = _flbl(ov, "term", 24, Color(0.7, 1.0, 0.7))
    pc_sig.position = Vector2(470, 8)
    pc_tag = _flbl(ov, "bold", 15, Color(1, 1, 1))
    pc_tag.position = Vector2(14, 370)
    pc_tag.custom_minimum_size = Vector2(560, 0)
    pc_tag.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    pc_tag.add_theme_stylebox_override("normal", _style(Color(0, 0, 0, 0.6), Color(0, 0, 0, 0)))
    pc_conv = _flbl(left, "bold", 17, Color(0.6, 1.0, 0.62))
    pc_conv_bar = ProgressBar.new()
    pc_conv_bar.show_percentage = false
    pc_conv_bar.custom_minimum_size = Vector2(0, 22)
    var cbg := StyleBoxFlat.new()
    cbg.bg_color = Color(0.05, 0.08, 0.05)
    cbg.border_color = Color(0.3, 0.6, 0.3)
    cbg.set_border_width_all(1)
    var cfg := StyleBoxFlat.new()
    cfg.bg_color = Color(0.4, 0.95, 0.45)
    pc_conv_bar.add_theme_stylebox_override("background", cbg)
    pc_conv_bar.add_theme_stylebox_override("fill", cfg)
    left.add_child(pc_conv_bar)
    pc_god = _btn(left, Loc.t("btn_red"))
    pc_god.custom_minimum_size = Vector2(0, 46)
    pc_god.add_theme_color_override("font_color", Color(1.0, 0.45, 0.4))
    pc_god.add_theme_stylebox_override("normal", _style(Color(0.2, 0.02, 0.02), Color(0.9, 0.2, 0.15)))
    pc_god.pressed.connect(_press_red)
    pc_mg_btn = _btn(left, Loc.t("mg_button"))
    pc_mg_btn.pressed.connect(_start_minigame)

    # ---- colonne droite : terminal
    var v := VBoxContainer.new()
    v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    v.add_theme_constant_override("separation", 8)
    row.add_child(v)
    var head := _flbl(v, "term", 30, orange)
    head.text = Loc.f("pc_head", [MY_POD + 1, WHO[MY_POD]])
    pc_status = _flbl(v, "mono", 15, Color(1.0, 0.82, 0.6))
    pc_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

    pc_log = RichTextLabel.new()
    pc_log.bbcode_enabled = true
    pc_log.scroll_following = true
    pc_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
    pc_log.custom_minimum_size = Vector2(0, 260)
    pc_log.add_theme_font_override("normal_font", Loc.font("mono"))
    pc_log.add_theme_font_override("bold_font", Loc.font("bold"))
    pc_log.add_theme_font_size_override("normal_font_size", 17)
    pc_log.add_theme_font_size_override("bold_font_size", 17)
    pc_log.add_theme_stylebox_override("normal", _style(Color(0.01, 0.008, 0.005, 0.95), Color(0.35, 0.18, 0.06)))
    v.add_child(pc_log)

    pc_input = LineEdit.new()
    pc_input.placeholder_text = Loc.t("pc_placeholder")
    pc_input.add_theme_font_override("font", Loc.font("mono"))
    pc_input.add_theme_font_size_override("font_size", 18)
    pc_input.add_theme_color_override("font_color", Color(1.0, 0.9, 0.7))
    pc_input.add_theme_stylebox_override("normal", _style(Color(0.06, 0.035, 0.015), orange))
    pc_input.add_theme_stylebox_override("focus", _style(Color(0.1, 0.06, 0.02), Color(1.0, 0.85, 0.5)))
    pc_input.custom_minimum_size = Vector2(0, 44)
    pc_input.text_submitted.connect(_send_line)
    v.add_child(pc_input)

    var r2 := HBoxContainer.new()
    r2.add_theme_constant_override("separation", 8)
    v.add_child(r2)
    pc_answer = _btn(r2, Loc.t("btn_answer"))
    pc_answer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    pc_answer.pressed.connect(_answer)
    pc_hang = _btn(r2, Loc.t("btn_hang"))
    pc_hang.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    pc_hang.pressed.connect(_hang_up)

    var g := GridContainer.new()
    g.columns = 4
    g.add_theme_constant_override("h_separation", 6)
    g.add_theme_constant_override("v_separation", 6)
    v.add_child(g)
    for i in 8:
        var b := _btn(g, "")
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.add_theme_font_size_override("font_size", 13)
        b.pressed.connect(_use_power.bind(i))
        pc_btns.append(b)

    var up := _btn(v, Loc.t("btn_stand"))
    up.pressed.connect(_stand)


func _build_coffee(cl: CanvasLayer) -> void:
    var cf := PanelContainer.new()
    cf.add_theme_stylebox_override("panel", _style(Color(0.07, 0.045, 0.02, 0.96), C_AMBER))
    cf.anchor_left = 0.5
    cf.anchor_right = 0.5
    cf.anchor_top = 0.5
    cf.anchor_bottom = 0.5
    cf.offset_left = -330
    cf.offset_right = 330
    cf.offset_top = -240
    cf.offset_bottom = 240
    cf.visible = false
    cl.add_child(cf)
    coffee_ui = cf

    var v := VBoxContainer.new()
    v.add_theme_constant_override("separation", 8)
    cf.add_child(v)
    var h := _lbl(v, 25, C_AMBER)
    h.text = Loc.t("cof_title")
    cof_lbl = _lbl(v, 19, Color(1.0, 0.95, 0.85))
    cof_lbl.custom_minimum_size = Vector2(0, 120)

    var g := GridContainer.new()
    g.columns = 4
    g.add_theme_constant_override("h_separation", 6)
    v.add_child(g)
    for i in 4:
        var b := _btn(g, Loc.f("cof_sugar", [i]))
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.pressed.connect(_set_sugar.bind(i))

    var b1 := _btn(v, Loc.t("cof_milk"))
    b1.pressed.connect(_toggle_milk)
    var b2 := _btn(v, Loc.t("cof_size"))
    b2.pressed.connect(_toggle_big)
    var b3 := _btn(v, Loc.t("cof_make"))
    b3.pressed.connect(_make_coffee)
    var b4 := _btn(v, Loc.t("cof_close"))
    b4.pressed.connect(_close_coffee)


func _tick_screens() -> void:
    for i in stat_lbls.size():
        var lbl: Label3D = stat_lbls[i]
        if float(stat_seed[i]) < 0.0:
            lbl.text = Loc.f("quota_screen", [solved, quota, day])
            continue
        var base: String = lbl.text
        var out := ""
        var phase: float = float(stat_seed[i]) + t * 0.6
        var n := 0
        for line in base.split("\n"):
            var txt := str(line)
            var pos := txt.rfind(" ")
            if pos > 0:
                var tail := txt.substr(pos + 1)
                if tail.length() > 0 and tail[0] >= "0" and tail[0] <= "9":
                    var num := tail.replace(" ", "")
                    if num.is_valid_int():
                        var v := int(num)
                        var drift := int(round(sin(phase + float(n) * 1.7) * max(1.0, float(v) * 0.002)))
                        v = max(0, v + drift)
                        txt = txt.substr(0, pos + 1) + str(v)
            out += txt + "\n"
            n += 1
        lbl.text = out.strip_edges()
        for k in stat_bars[i].size():
            var bar: Node3D = stat_bars[i][k]
            var hgt: float = 0.1 + abs(sin(phase * 0.8 + float(k) * 0.9)) * 0.5
            bar.scale.y = hgt / 0.3
            bar.position.y = -1.03 + hgt * 0.5


func _refresh_mouse() -> void:
    var ui: bool = seated or coffee_ui.visible or frozen or paused
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if ui else Input.MOUSE_MODE_CAPTURED
    crosshair.visible = not ui


# ------------------------------------------------------------- voix

func _say(text: String, secs: float) -> void:
    hud_main.text = text
    msg_time = secs


var tts_voices := PackedStringArray()
var tts_checked := false


func _speak(text: String, deep: bool, pitch := 1.0, rate := 1.0) -> void:
    if not tts_checked:
        tts_checked = true
        # Linux sans speech-dispatcher : pas de voix, on evite les erreurs en boucle
        if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH) and OS.get_name() != "Linux":
            tts_voices = DisplayServer.tts_get_voices_for_language(Loc.lang)
            if tts_voices.size() == 0:
                tts_voices = DisplayServer.tts_get_voices_for_language("en")
    if tts_voices.size() == 0:
        return
    DisplayServer.tts_stop()
    if deep:
        DisplayServer.tts_speak(text, tts_voices[0], 90, 0.4, 0.88)
    else:
        DisplayServer.tts_speak(text, tts_voices[tts_voices.size() - 1], 85, pitch, rate)


func _god(text: String) -> void:
    _say(Loc.t("god_prefix") + text, 7.0)
    god_label.text = text
    for g in god_texts:
        g.text = text
    last_god = t
    Sfx.play("god_speak", -12.0)
    _speak(text, true)


func _log(who: String, text: String, col: String) -> void:
    pc_log.append_text("[color=%s]%s[/color] %s\n\n" % [col, who, text])


func _add_expo(v: float) -> void:
    if Net.active and not Net.is_host():
        if v > 0.0:
            vignette.color.a = 0.3
        sync.to_host(&"add_expo", [v])
        return
    if v > 0.0:
        if Game.mood == "audit":
            v *= 2.0
        if Game.has("jammer"):
            v *= 0.65
    expo = clamp(expo + v, 0.0, 100.0)
    Game.stats["max_expo"] = max(float(Game.stats.get("max_expo", 0.0)), expo)
    if v > 0.0:
        vignette.color.a = 0.3


# ------------------------------------------------------------- journee de travail

func _begin_day() -> void:
    day = Game.day
    Stream.new_day()
    if fun != null:
        fun.apply_shame(Game.stats.get("shame", {}))
    SteamNet.presence("office", str(day))
    quota = Game.quota()
    solved = 0
    missed = 0
    expo = expo * 0.6
    madness = clamp(float(day - 1) * 0.15, 0.0, 0.8)
    in_call = false
    ringing = false
    task_on = false
    rule = ""
    rule_kind = ""
    lights_on = true
    blackout_left = 0.0
    next_blackout = randf_range(30.0, 60.0)
    soon_warned = false
    quota_warned = false
    shift_left = Game.SHIFT_SECONDS
    god_ready = true
    god_cool = 0.0
    if seated:
        _stand()
    # gravite (humeur "mise a jour")
    var g := 2.6 if Game.mood == "update" else 9.8
    PhysicsServer3D.area_set_param(get_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, g)
    _build_powers()
    hoops = 0
    screen_labels[MY_POD].text = Loc.f("pod_label", [MY_POD + 1, WHO[MY_POD]])
    pc_log.clear()
    frozen = true
    overlay.show_intro()
    _refresh_mouse()


func _on_start_shift() -> void:
    overlay.close()
    Game.mission_news.clear()
    frozen = false
    next_ring = t + 4.0
    next_task = t + (20.0 if Game.mood == "hungry" else 50.0)
    _refresh_mouse()
    var moods := Loc.dict("moods")
    var m: Array = moods.get(Game.mood, moods["normal"])
    _god(str(m[0]) + ".")
    Sfx.play("bell_shift", -8.0)
    if Game.mood == "update":
        _say(Loc.t("jump_hint"), 5.0)
    elif echoes != null and Game.day == 1:
        get_tree().create_timer(7.5).timeout.connect(_say.bind(Loc.t("echo_hint"), 7.0))
    if Game.day == 1:
        get_tree().create_timer(2.5).timeout.connect(_echo_notice)
    if Net.active and Net.is_host():
        sync.bcast(&"start_shift")
    if tutorial == null and Game.day == 1 and not Net.active and (not Loc.tutorial_done or Dev.args.has("tuto")) and not (Dev.args.has("autoplay") and not Dev.args.has("tuto")):
        tutorial = preload("res://scripts/tutorial.gd").new()
        tutorial.main = self
        add_child(tutorial)


func _end_shift() -> void:
    _end_shift_local()
    var res := Game.end_day(solved)
    _finish_or_shop(res)


func _end_shift_local() -> void:
    if missions != null:
        missions.end_call()
    if in_call:
        in_call = false
        hist = []
        if callview != null:
            callview.hang_up()
    ringing = false
    task_on = false
    if held != null:
        held = null
    if seated:
        _stand()
    if coffee_ui.visible:
        _close_coffee()
    lights_on = true
    blackout_left = 0.0
    frozen = true
    Sfx.stop("ring")
    Sfx.stop("heart")
    Sfx.play("bell_shift", -4.0)
    _god(Loc.t("shift_over"))
    if pod_video_quads.has(MY_POD):
        _call_net("hang", null)


func _finish_or_shop(res: String) -> void:
    paused = false
    var record := false
    _pick_shame()
    if res == "fired" or res == "week_done":
        record = Game.save_weekly()
        overlay.show_review(record)
    else:
        overlay.show_end(res, solved, quota)
    _refresh_mouse()
    if Net.active and Net.is_host():
        sync.bcast(&"end_shift", [{"res": res, "solved": solved, "quota": quota, "record": record,
            "strikes": Game.strikes, "earned": Game.earned, "wallet": Game.wallet, "owned": Game.owned,
            "fired": Game.fired, "finished": Game.finished, "stats": Game.stats, "best_quote": Game.best_quote,
            "converted": Game.converted, "gazette": Game.gazette}])


## Tirage de la honte : le pire employe de la journee portera le chapeau de cancre demain.
func _pick_shame() -> void:
    var sh := {}
    if Net.active:
        var dg: Dictionary = Game.stats.get("day_gain", {})
        var worst_id := -1
        var worst_v := 1 << 30
        for pid in Net.players:
            var v := int(dg.get(str(Net.players[pid]["name"]), 0))
            if v < worst_v or (v == worst_v and randf() < 0.5):
                worst_v = v
                worst_id = int(pid)
        sh = {"k": "peer", "id": worst_id, "name": str(Net.players.get(worst_id, {}).get("name", "?")), "gain": worst_v}
    elif solved < quota:
        sh = {"k": "peer", "id": Net.my_id(), "name": str(WHO[MY_POD]), "gain": 0}
    else:
        var pod := int(npcs[randi() % npcs.size()]["pod"]) if not npcs.is_empty() else 1
        sh = {"k": "npc", "id": pod, "name": str(WHO[pod]), "gain": 0}
    Game.stats["shame"] = sh
    Game.stats["day_gain"] = {}


# ------------------------------------------------------------- REALITY ECHO (raccords)

## Ce que les joueurs disent/ecrivent : vers la memoire de la simulation (chez l'hote).
func echo_hear(txt: String, ctx: String, who := "") -> void:
    if not Net.active or Net.is_host():
        Reality.hear(txt, who if who != "" else (str(WHO[MY_POD]) if not Net.active else Net.my_name), ctx)
    else:
        sync.bcast(&"action", ["echo_hear", {"t": txt, "ctx": ctx, "who": who}])


func echo_promise(txt: String, target: String) -> void:
    if not Net.active or Net.is_host():
        Reality.add_promise(txt, str(WHO[MY_POD]) if not Net.active else Net.my_name, target)
    else:
        sync.bcast(&"action", ["echo_promise", {"t": txt, "target": target}])


## Test : 3 joueurs simules qui disent des niaiseries (la simulation ecoute).
func _echo_test() -> void:
    if Dev.args.has("echoreset"):
        Reality.reset_world()
    var lines := [
        ["SAMUEL", "Imagine si les pigeons étaient les caméras de Dieu"],
        ["CORINNE", "Ouais les pigeons c'est des caméras, ils nous regardent tout le temps"],
        ["JULIE", "Imagine une religion basée sur les pigeons caméras"],
        ["SAMUEL", "Gérard va encore appeler, je le sens"],
        ["CORINNE", "Ah non, pas Gérard encore"],
        ["JULIE", "Gérard c'est notre meilleur client"],
        ["SAMUEL", "Imagine si la Terre était vraiment plate"],
        ["CORINNE", "La Terre est plate, tout le monde le sait"],
        ["JULIE", "Si la Terre est plate, l'eau tombe sur les côtés"],
    ]
    var i := 0
    while is_inside_tree():
        await get_tree().create_timer(2.5).timeout
        var l: Array = lines[i % lines.size()]
        Reality.hear(str(l[1]), str(l[0]), "voice" if i % 4 != 0 else "call")
        i += 1


func _echo_notice() -> void:
    if frozen:
        return
    fun.pop(cam.global_position - cam.global_transform.basis.z * 2.2 + Vector3(0, 0.6, 0), Loc.t("echo_tagline"), Color(0.45, 1.0, 0.7), 110)
    var hint := Loc.t("echo_open_hint") if Loc.voice_mode == 1 else Loc.t("echo_ptt_hint")
    _say(Loc.f("echo_notice_listen", [hint]) if listener != null and listener.listening() else Loc.t("echo_notice_text"), 8.0)
    Sfx.play("glitch", -10.0)


func clock_text() -> String:
    return "%s %s" % [day_name(), _clock()]


## Nom du jour... sauf si la simulation a decide que c'est TOUJOURS lundi.
func day_name() -> String:
    if Reality.hooks.has("monday"):
        return Loc.f("echo_monday", [day])
    var names := Loc.list("day_names")
    return str(names[clampi(day - 1, 0, names.size() - 1)])


## CONSEQUENCE : apres une mission reussie, le conjoint (ou un proche) appellera.
func queue_consequence(b: Dictionary, news: String) -> void:
    # pas a chaque fois (sinon les consequences mangent toutes les prieres)
    if pending_calls.size() >= 2 or randf() > (0.9 if Dev.args.has("echotest") else 0.45):
        return
    var c: Dictionary = adult_believer(not bool(b.get("fem", false)))
    var last := str(b.get("name", "")).split(" ")
    c["name"] = str(c["name"]).split(" ")[0] + (" " + last[last.size() - 1] if last.size() > 1 else "")
    c["kind"] = "consequence"
    c["start"] = 5
    c["pers_prompt"] = str(c["pers_prompt"]) + Loc.f("ai_consequence", [str(b.get("name", "?")), news])
    pending_calls.append(c)


## Un fidele adulte du genre voulu (conjoint, mari/femme des prieres croisees).
func adult_believer(fem: bool) -> Dictionary:
    var c: Dictionary = Believers.make(Loc.lang, Game.rng)
    for i in 30:
        if int(c["age"]) >= 21 and bool(c["fem"]) == fem:
            break
        c = Believers.make(Loc.lang, Game.rng)
    return c


## PRIERES CROISEES (co-op) : l'hote envoie le mari a un joueur, la femme a un autre.
var cross_t := 150.0


func _cross_prayers(dt: float) -> void:
    if not Net.active or not Net.is_host() or Net.ready_peers.size() < 2:
        return
    cross_t -= dt
    if cross_t > 0.0:
        return
    cross_t = randf_range(200.0, 320.0) if not Dev.args.has("echotest") else 30.0
    var ids: Array = Net.ready_peers.duplicate()
    ids.shuffle()
    var a: Dictionary = adult_believer(false)
    var b2: Dictionary = adult_believer(true)
    var last := str(a["name"]).split(" ")
    b2["name"] = str(b2["name"]).split(" ")[0] + " " + last[last.size() - 1]
    var conflict := Loc.pick("cross_conflicts")
    a["kind"] = "cross"
    b2["kind"] = "cross"
    a["pers_prompt"] = str(a["pers_prompt"]) + Loc.f("ai_cross", [str(b2["name"]), conflict])
    b2["pers_prompt"] = str(b2["pers_prompt"]) + Loc.f("ai_cross", [str(a["name"]), conflict])
    for pair in [[ids[0], a], [ids[1], b2]]:
        if int(pair[0]) == Net.my_id():
            pending_calls.push_front(pair[1])
        else:
            sync.rpc_id(int(pair[0]), &"action", "cross", pair[1])


func _on_next_day() -> void:
    if Net.active and not Net.is_host():
        return
    overlay.close()
    Game.next_day()
    if Net.active:
        sync.bcast(&"next_day", [{"day": Game.day, "mood": Game.mood, "gazette": Game.gazette, "strikes": Game.strikes}])
    _begin_day()


func _on_again() -> void:
    if Net.active:
        if not Net.is_host():
            return
        var sd := randi()
        sync.bcast(&"again", [sd])
        net_again(sd)
        return
    Game.new_run(Game.weekly)
    get_tree().reload_current_scene()


func _on_menu() -> void:
    DisplayServer.tts_stop()
    Sfx.stop_all()
    if Net.active:
        Net.leave()
    PhysicsServer3D.area_set_param(get_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 9.8)
    get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _pause() -> void:
    if frozen or paused:
        return
    paused = true
    if not Net.active:
        frozen = true
    overlay.show_pause()
    _refresh_mouse()


func _on_resume() -> void:
    if not paused:
        return
    paused = false
    overlay.close()
    if not Net.active:
        frozen = false
    _refresh_mouse()


func _clock() -> String:
    var frac: float = clamp(1.0 - shift_left / Game.SHIFT_SECONDS, 0.0, 1.0)
    var mins := 9 * 60 + int(frac * 480.0)
    var h := int(floor(mins / 60.0))
    var mm := mins - h * 60
    if Loc.lang == "fr":
        return "%dh%02d" % [h, mm]
    var h12 := h if h <= 12 else h - 12
    return "%d:%02d %s" % [h12, mm, "a.m." if h < 12 else "p.m."]


func _mood_name() -> String:
    var moods := Loc.dict("moods")
    var m: Array = moods.get(Game.mood, moods["normal"])
    return str(m[0])


func _build_powers() -> void:
    active_powers = []
    for i in POWERS.size():
        active_powers.append([str(POWERS[i]), str(POWER_TXT[i]), POWER_IDS[i % POWER_IDS.size()]])
    var shop := Loc.dict("shop")
    var txts := Loc.dict("power_new")
    for id in Game.owned_powers():
        active_powers.append([str(shop[id][0]), str(txts[id]), str(id)])
    for i in pc_btns.size():
        var b: Button = pc_btns[i]
        b.visible = i < active_powers.size()
        if b.visible:
            b.text = "[%d] %s" % [i + 1, active_powers[i][0]]


# ------------------------------------------------------------- IA

func _sys_prompt() -> String:
    var b := cur_b
    var s := ""
    if str(b.get("kind", "")) == "conference":
        var o: Dictionary = b["other"]
        s = Loc.f("ai_role_conf", [str(b["name"]), int(b["age"]), str(o["name"]), int(o["age"]), str(b["relation"]),
            str(b["place"]), str(b["situation"]), str(b["name"]), str(b["shame"]), str(o["name"]),
            str(b["pers_prompt"]), str(o["pers_prompt"])])
    else:
        s = Loc.f("ai_role", [str(b["name"]), int(b["age"]), str(b["place"]), str(b["situation"]), str(b["shame"]), str(b["pers_prompt"])])
        if str(b.get("kind", "")) == "callback":
            s += Loc.t("ai_role_cb")
    if str(b.get("kind", "")) == "callback" and b.has("mission_news"):
        s += Loc.f("ai_role_cb_mission", [str(b["mission_news"])])
    if str(b.get("kind", "")) == "callback" and b.has("promises"):
        s += Loc.f("ai_role_cb_promise", ["; ".join(PackedStringArray(b["promises"]))])
    s += Reality.rules_prompt()
    s += Loc.t("ai_promise_field")
    s += Loc.t("ai_rules")
    s += missions.ai_prompt()
    if Game.mood == "memes":
        s += Loc.t("ai_mood_memes")
    elif Game.mood == "openhouse":
        s += Loc.t("ai_mood_openhouse")
    return s


func _ask_ai(line: String) -> void:
    hist.append(line)
    if api_key == "" and not relay_ok():
        _fallback(line)
        return
    busy = true
    pc_input.editable = false
    _log(Loc.t("log_system"), "...", "#4a7a8a")
    # on garde la FIN de la conversation (limites du relais : ~9000 caracteres)
    var convo := ""
    for i in range(hist.size() - 1, -1, -1):
        var ln := str(hist[i]).substr(0, 400) + "\n"
        if convo.length() + ln.length() > 6500:
            convo = "[...]\n" + convo
            break
        convo = ln + convo
    var msgs := [{"role": "user", "content": Loc.f("ai_user", [int(expo), convo])}]
    var body := {
        "model": AI_MODEL,
        "max_tokens": 450,
        "system": _sys_prompt(),
        "messages": msgs
    }
    var err: int
    lat_send = Time.get_ticks_msec()
    lat_first = 0
    lat_say = 0
    st_bytes = PackedByteArray()
    st_text = ""
    st_said = ""
    if Loc.ai_stream:
        # STREAMING : on lit la reponse au fil de l'eau ; des que la replique
        # (« say ») est complete, le fidele parle, sans attendre le reste du JSON
        body["stream"] = true
        var url := "https://api.anthropic.com/v1/messages"
        var hs := PackedStringArray(["content-type: application/json", "x-api-key: " + api_key, "anthropic-version: 2023-06-01"])
        if api_key == "":
            body.erase("model")
            body.erase("max_tokens")
            body["system"] = str(body["system"]) + "\n(G.O.D. prayer center)"
            body["player"] = Relay.player
            body["lang"] = Loc.lang
            url = Relay.url + "/v1/chat"
        var js_s := JSON.stringify(body)
        if api_key == "":
            hs = Relay.headers(js_s)
        if ai_stream.start(url, hs, js_s.to_utf8_buffer()):
            return
        # echec de connexion immediat : on retombe sur la requete classique
        body.erase("stream")
        if api_key == "":
            body["system"] = str(body["system"]).trim_suffix("\n(G.O.D. prayer center)")
    if api_key != "":
        var headers := [
            "content-type: application/json",
            "x-api-key: " + api_key,
            "anthropic-version: 2023-06-01"
        ]
        err = http.request("https://api.anthropic.com/v1/messages", headers, HTTPClient.METHOD_POST, JSON.stringify(body))
    else:
        # version commerciale : on passe par le relais (aucune cle dans le jeu)
        body.erase("model")
        body.erase("max_tokens")
        body["system"] = str(body["system"]) + "\n(G.O.D. prayer center)"
        body["player"] = Relay.player
        body["lang"] = Loc.lang
        var js := JSON.stringify(body)
        err = http.request(Relay.url + "/v1/chat", Relay.headers(js), HTTPClient.METHOD_POST, js)
    if err != OK:
        busy = false
        pc_input.editable = true
        _log(Loc.t("log_system"), Loc.t("ai_noconn"), "#ff6666")
        _fallback(line)


# ------------------------------------------------------------- IA en streaming

func _on_ai_chunk(data: PackedByteArray) -> void:
    if lat_first == 0:
        lat_first = Time.get_ticks_msec() - lat_send
    st_bytes.append_array(data)
    # on ne decode que des lignes completes (un caractere UTF-8 peut etre coupe en deux)
    var nl := st_bytes.rfind(10)
    if nl < 0:
        return
    var block := st_bytes.slice(0, nl + 1).get_string_from_utf8()
    st_bytes = st_bytes.slice(nl + 1)
    for ln in block.split("\n", false):
        if not ln.begins_with("data:"):
            continue
        var ev = Reality.quiet_json(ln.substr(5).strip_edges())
        if typeof(ev) != TYPE_DICTIONARY:
            continue
        if str(ev.get("type", "")) == "content_block_delta":
            var dl = ev.get("delta", {})
            if typeof(dl) == TYPE_DICTIONARY:
                st_text += str(dl.get("text", ""))
    if st_said == "" and in_call:
        var say := _partial_say(st_text)
        if say != "":
            # la replique est complete : le fidele parle TOUT DE SUITE
            lat_say = Time.get_ticks_msec() - lat_send
            st_said = say
            _show_line(say)


func _on_ai_done(code: int, ok: bool) -> void:
    if not ok:
        _on_http(0, code if code != 200 else 0, PackedStringArray(), ai_stream.body_all)
        return
    var full := {"content": [{"type": "text", "text": st_text}]}
    _on_http(0, 200, PackedStringArray(), JSON.stringify(full).to_utf8_buffer())
    var tot := Time.get_ticks_msec() - lat_send
    lat_log.append([lat_first, lat_say, tot])
    print("LATENCE IA : premier mot %d ms, replique %d ms, fin %d ms" % [lat_first, lat_say, tot])


## Extrait la valeur de "say" quand elle est COMPLETE dans un JSON encore incomplet.
static func _partial_say(txt: String) -> String:
    var k := txt.find("\"say\"")
    if k < 0:
        return ""
    var q := txt.find("\"", txt.find(":", k + 5) + 1)
    if q < 0:
        return ""
    var out := ""
    var i := q + 1
    while i < txt.length():
        var c := txt[i]
        if c == "\\":
            if i + 1 >= txt.length():
                return ""
            var n := txt[i + 1]
            match n:
                "n":
                    out += "\n"
                "t":
                    out += " "
                "u":
                    if i + 5 >= txt.length():
                        return ""
                    out += char(txt.substr(i + 2, 4).hex_to_int())
                    i += 4
                _:
                    out += n
            i += 2
            continue
        if c == "\"":
            return out.strip_edges()
        out += c
        i += 1
    return ""


func _on_http(_r: int, code: int, _h: PackedStringArray, bytes: PackedByteArray) -> void:
    busy = false
    if code == 200:
        relay_fails = 0
    pc_input.editable = true
    if not in_call:
        return
    if code != 200:
        if code == 429:
            _log(Loc.t("log_system"), Loc.t("ai_busy"), "#ff6666")
            relay_wait = 25.0        # on souffle : le fidele repond en mode hors ligne un moment
        else:
            _log(Loc.t("log_system"), Loc.f("ai_err", [code]), "#ff6666")
            if api_key != "":
                api_key = ""
            else:
                relay_fails += 1
        _fallback("")
        return
    var raw := bytes.get_string_from_utf8()
    var data = Reality.quiet_json(raw)
    if typeof(data) != TYPE_DICTIONARY or not data.has("content"):
        _log(Loc.t("log_system"), Loc.t("ai_bad"), "#ff6666")
        return
    var txt := ""
    for blk in data["content"]:
        if typeof(blk) == TYPE_DICTIONARY and blk.get("type", "") == "text":
            txt += str(blk.get("text", ""))
    txt = txt.replace("```json", "").replace("```", "").strip_edges()
    var a := txt.find("{")
    var z := txt.rfind("}")
    if a >= 0 and z > a:
        txt = txt.substr(a, z - a + 1)
    var obj = Reality.quiet_json(txt)
    if typeof(obj) != TYPE_DICTIONARY:
        _reply(txt, expo, false)
        return
    conviction = int(clamp(float(obj.get("conviction", conviction)), 0.0, 100.0))
    if bool(obj.get("mission", false)):
        missions.success()
    var prom := str(obj.get("promise", "")).strip_edges()
    if prom != "" and prom.length() > 6:
        var pl: Array = cur_b.get("promises", [])
        if not (prom in pl):
            pl.append(prom)
            cur_b["promises"] = pl
            echo_promise(prom, str(cur_b.get("name", "?")))
    last_headline = str(obj.get("headline", ""))
    _reply(str(obj.get("say", "...")), float(obj.get("exposure", expo)), bool(obj.get("done", false)) or conviction >= 100)


func _reply(say: String, new_expo: float, done: bool) -> void:
    if st_said != "" and say.strip_edges() == st_said:
        # deja affichee et dite pendant le streaming : on met juste l'etat a jour
        st_said = ""
        if callview != null and in_call:
            callview.set_conviction(conviction)
            _call_net("conv", {"conv": conviction})
    else:
        st_said = ""
        _show_line(say)
    if new_expo > expo:
        _add_expo(new_expo - expo)
    else:
        expo = clamp(new_expo, 0.0, 100.0)
    if done:
        _resolve()


## Affiche et fait dire une replique du fidele.
func _show_line(say: String) -> void:
    hist.append(call_human + " : " + say)
    call_lines += 1
    last_line = say
    if callview != null and in_call:
        callview.line(say)
        callview.set_conviction(conviction)
        _call_net("line", {"text": say, "conv": conviction})
    _log(call_human.to_upper() + " :", say, "#9fe8ff")
    # chaque fidele a sa voix (aigue, grave, rapide, lente...)
    var vs := int(cur_b.get("look_seed", 7))
    var vp := 0.55 + float(vs % 100) / 100.0 * 1.25
    var vr := 0.85 + float((vs / 100) % 50) / 100.0
    match str(cur_b.get("pers", "")):
        "kid":
            vp = 1.8
        "chatty":
            vr = 1.45
        "shy":
            vr = 0.8
    if tts == null or not tts.speak(say, cur_b):
        _speak(say, false, vp, vr)
    if echoes != null and call_lines >= 1 and randf() < (0.35 if Dev.args.has("crossed") else 0.09):
        get_tree().create_timer(2.8).timeout.connect(echoes.crossed_line)


func _fallback(line: String) -> void:
    var r := ""
    var gain := int(cur_b.get("gain", 20))
    if Game.mood == "openhouse":
        gain += 6
    if line.begins_with(EVENT_TAG):
        conviction = min(100, conviction + 18)
        r = Loc.t("fb_event")
    elif hist.size() <= 1:
        match str(cur_b.get("kind", "")):
            "conference":
                var o: Dictionary = cur_b["other"]
                r = Loc.f("fb_first_conf", [str(cur_b["name"]), str(o["name"]), str(cur_b["name"]), call_motive])
            "callback":
                r = Loc.f("fb_first_cb", [str(cur_b["name"])])
            _:
                r = Loc.f("fb_first", [call_motive])
        if cur_b.has("echo_first"):
            r = Loc.f("fb_first_echo", [str(cur_b["echo_quote"])])
    else:
        # mode hors ligne : on juge grossierement la qualite de l'argument
        var q := _offline_quality(line)
        conviction = clamp(conviction + int(round(gain * q)), 0, 100)
        if q < 0.0:
            r = Loc.pick("fb_bad")
        else:
            r = Loc.pick("fb_lines")
    _reply(r, expo, conviction >= 100)


func _offline_quality(line: String) -> float:
    var txt := line.to_lower()
    for pre in [Loc.t("mk_employee").to_lower()]:
        txt = txt.trim_prefix(pre)
    var n := txt.length()
    var q := 0.25
    if n > 25:
        q = 0.7
    if n > 60:
        q = 1.0
    if n > 120:
        q = 1.2
    for w in Loc.list("fb_keywords"):
        if txt.find(str(w)) >= 0:
            q += 0.25
    if txt == last_player_line:
        q = -0.6
    last_player_line = txt
    if txt.find("simulation") >= 0:
        _add_expo(15.0)
        q = -0.5
    return min(q, 2.0) * randf_range(0.75, 1.25)


# ------------------------------------------------------------- boucle

func _process(dt: float) -> void:
    t += dt
    # le relais a eu des pepins : on lui redonne une chance toutes les 90 s (temps reel)
    relay_wait -= dt / maxf(0.01, Engine.time_scale)
    if relay_fails > 0:
        relay_cool += dt / maxf(0.01, Engine.time_scale)
        if relay_cool > 90.0:
            relay_cool = 0.0
            relay_fails -= 1
    if not load_ok and t > 3.0:
        load_ok = true
        Loc.set_loading(false)
    if msg_time > 0.0:
        msg_time -= dt
        if msg_time <= 0.0:
            hud_main.text = ""
    vignette.color.a = max(0.0, vignette.color.a - dt * 0.4)

    core.rotation.y += dt * 0.22
    if earth != null:
        earth.rotation.y += dt * 0.12
        earth.position.y = 4.15 + sin(t * 0.7) * 0.06
    if halo != null:
        halo.rotation.y -= dt * 0.07
    stat_t += dt
    if stat_t > 0.45:
        stat_t = 0.0
        _tick_screens()
    core_mat.emission_energy_multiplier = 2.3 + sin(t * 1.6) * 0.6
    core_light.light_energy = 2.6 + sin(t * 1.6) * 0.6
    var corrupt := C_AMBER.lerp(Color(1.0, 0.1, 0.5), madness)
    core_mat.emission = corrupt
    core_light.light_color = corrupt
    god_label.modulate = corrupt

    # REECRITURE « nuit eternelle » : le bureau reste dans la penombre (jouable)
    var night_k: float = 0.3 if Reality.hooks.has("night") else 1.0
    for l in ring_lights:
        var le: float = LIGHT_ON_E * night_k if lights_on else 0.04
        l.light_energy = lerp(l.light_energy, le, dt * 6.0)
    for m in strip_mats:
        m.emission = C_CYAN.lerp(C_RED, madness)
        var se: float = 2.4 * night_k if lights_on else 0.2
        m.emission_energy_multiplier = lerp(m.emission_energy_multiplier, se, dt * 5.0)

    if flashlight != null:
        var fe: float = 3.2 if flash_on else 0.0
        if flash_on and madness > 0.3 and randf() < dt * madness * 3.0:
            fe = 0.3
        flashlight.light_energy = lerp(flashlight.light_energy, fe, dt * 14.0)

    if autoplay:
        _autoplay(dt)
    _tick_leds(dt)
    _track_eyes(dt)
    _npcs(dt)
    _gauge()
    if expo > 65.0 and not frozen:
        if not heart_on:
            heart_on = true
            Sfx.loop("heart", "heartbeat", -30.0)
        Sfx.set_loop_db("heart", lerp(-24.0, -4.0, clamp((expo - 65.0) / 35.0, 0.0, 1.0)))
    elif heart_on:
        heart_on = false
        Sfx.stop("heart")
    _hud_top()
    if frozen:
        return

    # ---- tout ce qui suit ne tourne que pendant le quart
    var host := Net.is_host()
    if host:
        shift_left -= dt
    if shift_left <= 30.0 and not soon_warned:
        soon_warned = true
        _say(Loc.t("shift_soon"), 4.0)
    if host and shift_left <= 0.0:
        _end_shift()
        return

    board_t += dt
    if board_t > 1.0:
        board_t = 0.0
        _update_board(host)
    if not god_ready:
        god_cool -= dt
        if god_cool <= 0.0:
            god_ready = true
    if red_mat != null:
        var re: float = 2.6 if (god_ready and in_call) else (1.2 if god_ready else 0.25)
        if Game.mood == "wifi":
            re = 0.1
        red_mat.emission_energy_multiplier = lerp(red_mat.emission_energy_multiplier, re, dt * 5.0)
    _calls(dt)
    _tick_avatars(dt)
    if emote_t > 0.0:
        emote_t -= dt
        if emote_t <= 0.0:
            cur_emote = ""
    if host:
        _tasks(dt)
        _cross_prayers(dt)
        _rules(dt)
        _blackouts(dt)
        _events(dt)
        _mass(dt)
    else:
        _rules_client()
        _shake_tick(dt)
    _hold()
    _target()
    if seated:
        _update_status()
    else:
        _update_video()

    if host and not task_on and t - last_god > 34.0 and randf() < dt * (0.3 if Game.mood == "midlife" else 0.13):
        if Game.mood == "memes" and randf() < 0.7:
            _god_all(Loc.pick("god_idle_memes"))
        elif Game.mood == "midlife" and randf() < 0.7:
            _god_all(Loc.pick("god_idle_midlife"))
        else:
            _god_all(Loc.pick("god_idle"))


func _hud_top() -> void:
    var dn := day_name()
    hud_top.text = "%s  ·  %s" % [dn, _clock()]
    hud_mood.text = Loc.t("hud_mood") + _mood_name()
    var pips := ""
    for i in max(quota, solved):
        pips += "■ " if i < solved else "□ "
    hud_quota.text = Loc.f("hud_quota", [solved, quota]) + "\n" + pips.strip_edges()
    hud_money.text = ("%d $" % Game.earned) if Loc.lang == "fr" else ("$%d" % Game.earned)
    hud_expo.value = expo
    var sk := ""
    for i in Game.MAX_STRIKES:
        sk += " X" if i < Game.strikes else " ·"
    hud_strikes.text = Loc.t("hud_strikes") + sk
    var ob := ""
    if frozen:
        ob = ""
    elif mass_left > 0.0:
        ob = Loc.f("obj_mass_disco" if mass_disco else "obj_mass", [int(ceil(mass_left))])
    elif ringing and not seated:
        ob = Loc.t("obj_ring")
    elif ringing:
        ob = Loc.t("obj_answer")
    elif in_call and not seated:
        ob = Loc.f("obj_back", [call_human])
    elif in_call:
        ob = Loc.f("obj_convince", [call_human])
    elif task_on and held == null:
        ob = Loc.t("obj_coffee")
    elif task_on:
        ob = Loc.t("obj_deliver")
    elif solved >= quota:
        ob = Loc.t("obj_bonus")
    else:
        ob = Loc.t("obj_wait")
    if Net.i_am_satan() and not frozen:
        ob += "\n" + Loc.t("satan_hud")
    if missions != null and not frozen:
        var mt: String = missions.hud_text()
        if mt != "":
            ob += ("\n" if ob != "" else "") + mt
    if shamed and not frozen:
        ob += ("\n" if ob != "" else "") + Loc.t("shame_hud")
    if delivery != null and not frozen:
        var dl: String = delivery.hud_text()
        if dl != "":
            ob += ("\n" if ob != "" else "") + dl
    hud_obj.text = ("> " + ob) if ob != "" else ""
    if voice != null:
        hud_mic.visible = true
        if voice.transmitting:
            hud_mic.text = (Loc.t("mic_radio") if voice.radio else Loc.t("mic_on")) + "  " + "|".repeat(int(clampf(voice.level * 60.0, 1.0, 12.0)))
            hud_mic.modulate = Color(1, 1, 1, 1)
        else:
            hud_mic.text = Loc.t("mic_hint") if Loc.voice_mode == 0 else (Loc.t("mic_open") if Loc.voice_mode == 1 else Loc.t("mic_off"))
            hud_mic.modulate = Color(1, 1, 1, 0.45)
        if hud_voicefx != "":
            hud_mic.text += "\n" + hud_voicefx
    hud_obj.modulate.a = 0.75 + 0.25 * sin(t * 3.0) if (ringing or task_on) else 0.8


func _events(dt: float) -> void:
    # petits evenements d'ambiance pour que le bureau soit vivant
    if flicker_t > 0.0:
        flicker_t -= dt
        lights_on = randf() < 0.6 if flicker_t > 0.0 else true
    _shake_tick(dt)
    next_event -= dt
    if next_event > 0.0:
        return
    next_event = randf_range(60.0, 110.0)
    match randi() % 4:
        0:
            if Game.mood != "monday":
                flicker_t = 2.5
                Sfx.play("power_down", -12.0, 1.6)
        1:
            _recompile_someone()
        2:
            net_fx_event("sneeze", null)
            if Net.active:
                sync.bcast(&"fx_event", ["sneeze", null])
            _god_all(Loc.pick("god_sneeze"))
        3:
            _god_all(Loc.pick("god_memo"))


func _recompile_someone() -> void:
    var desk := []
    for d in npcs:
        if str(d["state"]) == "desk":
            desk.append(int(d["pod"]))
    if desk.is_empty():
        return
    var pod: int = desk[randi() % desk.size()]
    if Net.active and Net.is_host():
        sync.bcast(&"fx_event", ["recompile", pod])
    _recompile_pod(pod)


func _recompile_pod(pod: int) -> void:
    var dd: Dictionary = {}
    for d in npcs:
        if int(d["pod"]) == pod:
            dd = d
    if dd.is_empty():
        return
    var c = dd["char"]
    var hold: Node3D = dd["hold"]
    Sfx.play_at("error", hold.global_position, -6.0)
    var bub: Label3D = dd["bub"]
    bub.text = Loc.t("recompiling")
    dd["say"] = 3.0
    var tw := create_tween()
    tw.tween_property(c, "scale", Vector3(1.0, 0.02, 1.0), 0.6).set_trans(Tween.TRANS_BACK)
    tw.tween_interval(6.0)
    tw.tween_callback(func():
        var rng := RandomNumberGenerator.new()
        rng.randomize()
        var lk := Character.random_look(rng, {"fem": bool(dd["look"].get("fem", false))})
        lk["headset"] = true
        lk["badge"] = true
        dd["look"] = lk
        c.build(lk, "sit")
        c.typing = true
        Sfx.play_at("shimmer", hold.global_position, -8.0)
        bub.text = Loc.pick("recompiled")
        dd["say"] = 5.0
        c.set_emotion("dizzy")
        c.say(2.0))
    tw.tween_property(c, "scale", Vector3.ONE, 0.5).set_trans(Tween.TRANS_ELASTIC)


func _blackouts(dt: float) -> void:
    if Game.mood != "monday":
        if blackout_left > 0.0:
            blackout_left -= dt
            if blackout_left <= 0.0:
                lights_on = true
                Sfx.play("power_up", -4.0)
        return
    if blackout_left > 0.0:
        blackout_left -= dt
        if blackout_left <= 0.0:
            lights_on = true
            Sfx.play("power_up", -4.0)
            _say(Loc.t("blackout_end"), 3.0)
        return
    next_blackout -= dt
    if next_blackout <= 0.0:
        next_blackout = randf_range(35.0, 70.0)
        blackout_left = randf_range(9.0, 16.0)
        lights_on = false
        Sfx.play("power_down", -2.0)
        _say(Loc.t("blackout"), 4.0)


func _track_eyes(dt: float) -> void:
    blink_t -= dt
    var bl := 0.0
    if blink_t < 0.0:
        bl = 1.0
        if blink_t < -0.14:
            blink_t = randf_range(2.5, 6.0)
    var ang := clampf(madness + expo / 200.0, 0.0, 1.0)
    for pair in god_eyes:
        var arr: Array = pair
        var hold: Node3D = arr[0]
        var em: ShaderMaterial = arr[1]
        var lp: Vector3 = hold.to_local(player.global_position)
        var dz: float = max(1.5, abs(lp.z))
        var look := Vector2(clamp(-lp.x / dz, -1.0, 1.0), clamp((lp.y - 4.7) / dz, -1.0, 1.0))
        em.set_shader_parameter("look", look)
        em.set_shader_parameter("blink", bl)
        em.set_shader_parameter("anger", ang)
        em.set_shader_parameter("glitch", 1.0 if (madness > 0.3 and randf() < 0.02) else 0.0)
        var l: OmniLight3D = arr[2]
        l.light_color = Color(1.0, 0.55, 0.2).lerp(Color(1.0, 0.1, 0.05), ang)


func _update_board(drift: bool) -> void:
    if board_lbl == null:
        return
    if drift:
        for i in rivals.size():
            if i != MY_POD and randf() < 0.08:
                rivals[i] = int(rivals[i]) + randi_range(20, 130)
    money = Game.earned
    rivals[MY_POD] = money
    var order := []
    for i in rivals.size():
        order.append([int(rivals[i]), i])
    order.sort_custom(_sort_desc)
    var txt := ""
    for k in order.size():
        var e: Array = order[k]
        var nm: String = WHO[int(e[1])]
        var mark: String = Loc.t("you_mark") if int(e[1]) == MY_POD else ""
        var pad := nm
        while pad.length() < 10:
            pad += " "
        txt += "%d.   %s   %8d $%s\n" % [k + 1, pad, int(e[0]), mark]
    board_lbl.text = txt.strip_edges()
    if emp_lbl != null and order.size() > 0:
        var top: Array = order[0]
        emp_lbl.text = "%s\n%d $" % [WHO[int(top[1])], int(top[0])]


func _sort_desc(x: Array, y: Array) -> bool:
    return int(x[0]) > int(y[0])


func _ring_delay(base: float) -> float:
    return base * (0.45 if Game.mood == "rush" else 1.0)


func _calls(dt: float) -> void:
    var blink := fmod(t, 0.8) < 0.4
    for i in beam_mats.size():
        var act: bool = (i == MY_POD and ringing) or bool(remote_ring.get(i, false))
        if i != MY_POD and npc_calls.has(i):
            beam_mats[i].emission = Color(1.0, 0.55, 0.15)
            beam_mats[i].emission_energy_multiplier = 2.5
            continue
        beam_mats[i].emission = C_RED if act else Color(0.4, 0.33, 0.25)
        beam_mats[i].emission_energy_multiplier = 4.0 if (act and blink) else 0.3
        phone_mats[i].emission = C_RED if act else Color(0.95, 0.78, 0.4)
        phone_mats[i].emission_energy_multiplier = 3.0 if (act and blink) else 0.5
    screen_mats[MY_POD].emission = Color(0.9, 0.2, 0.25) if ringing else Color(0.22, 0.42, 0.72)

    if ringing:
        ring_left -= dt
        if ring_left <= 0.0:
            ringing = false
            Sfx.stop("ring")
            missed += 1
            _stat("missed")
            next_ring = t + _ring_delay(10.0)
            if not Game.has("intern"):
                _add_expo(5.0)
            screen_labels[MY_POD].text = Loc.f("scr_missed", [MY_POD + 1])
            _god(Loc.t("god_missed"))
    elif not in_call and t > next_ring and shift_left > 20.0:
        ringing = true
        ring_left = 30.0
        if minigame != null and minigame.running:
            _on_minigame_done(minigame.stop())
        Sfx.loop_at("ring", "phone_ring", ring_spot, -2.0)
        screen_labels[MY_POD].text = Loc.f("scr_ringing", [MY_POD + 1])
        _say(Loc.t("say_incoming"), 5.0)


func _tasks(dt: float) -> void:
    if task_on:
        task_left -= dt
        if task_left <= 0.0:
            task_on = false
            next_task = t + (30.0 if Game.mood == "hungry" else 60.0)
            _stat("coffee_bad")
            _add_expo(7.0)
            _god_all(Loc.t("god_forgot"))
        return
    if t > next_task:
        task_on = true
        task_sugar = randi() % 4
        task_milk = randf() < 0.5
        task_big = randf() < 0.5
        task_left = 160.0 if Game.has("coffee") else 100.0
        var fmt: String = Loc.t("big_l") if task_big else Loc.t("small_l")
        var mk: String = Loc.t("with_l") if task_milk else Loc.t("without_l")
        _god_all(Loc.f("god_order", [fmt, task_sugar, mk]))


func _task_text() -> String:
    if not task_on:
        return Loc.t("task_none")
    var fmt: String = Loc.t("big") if task_big else Loc.t("small")
    var mk: String = Loc.t("with") if task_milk else Loc.t("without")
    return Loc.f("task_text", [fmt, task_sugar, mk, int(task_left)])


func _rules(dt: float) -> void:
    var extra := ""
    if task_on:
        extra = Loc.t("order_head") + _task_text()
    if rule == "":
        hud_rule.text = extra.strip_edges()
        var chance := 0.025 * (3.0 if Game.mood == "midlife" else 1.0)
        if Game.SHIFT_SECONDS - shift_left > 40.0 and randf() < dt * chance:
            var r = RULES[randi() % RULES.size()]
            if Game.mood == "monday" and str(r[1]) == "dark":
                return
            rule = str(r[0])
            rule_kind = str(r[1])
            rule_left = 40.0
            rule_spot = player.global_position
            _god_all(rule)
        return
    rule_left -= dt
    hud_rule.text = Loc.f("rule_head", [rule, int(max(0.0, rule_left)), extra])
    if rule_left <= 0.0:
        rule = ""
        rule_kind = ""
        _say(Loc.t("rule_lifted"), 3.0)


func _break_rule(why: String, who := 0) -> void:
    if rule == "":
        return
    if Net.active and not Net.is_host():
        sync.to_host(&"rule_broken", [why])
        rule = ""
        Sfx.play("error", -4.0)
        return
    rule = ""
    rule_kind = ""
    _stat("rules_broken")
    if who == 0 or who == Net.my_id():
        Sfx.play("error", -4.0)
    _add_expo(8.0)
    var nm := ""
    if Net.active:
        nm = str(Net.players.get(who if who != 0 else 1, {}).get("name", "")) + " : "
    _god_all(nm + Loc.t("rule_broken") + why)


func _gauge() -> void:
    var lit := int(round(expo / 100.0 * 24.0))
    for i in gauge_mats.size():
        var m: StandardMaterial3D = gauge_mats[i]
        if i < lit:
            var c := Color(0.2, 1.0, 0.5).lerp(C_RED, float(i) / 24.0)
            m.emission = c
            m.albedo_color = c
            m.emission_energy_multiplier = 2.4
        else:
            m.emission = Color(0.09, 0.18, 0.23)
            m.emission_energy_multiplier = 0.35
    if expo >= 100.0 and not frozen and Net.is_host():
        # RUPTURE : un fidele a compris -> avertissement immediat
        expo = 45.0
        Sfx.play("thunder", 0.0)
        _god_all(Loc.t("god_broken"))
        viral.highlight("broken")
        Game.strikes += 1
        if Game.strikes >= Game.MAX_STRIKES and int(Game.owned.get("second", 0)) > 0:
            Game.owned["second"] = int(Game.owned["second"]) - 1
            Game.strikes -= 1
        if in_call:
            _hang_up()
        if Game.strikes >= Game.MAX_STRIKES:
            Game.fired = true
            Game.finished = true
            if seated:
                _stand()
            frozen = true
            _finish_or_shop("fired")


func _hold() -> void:
    if held == null:
        return
    if not is_instance_valid(held):
        held = null
        return
    held.linear_velocity = (hold_point.global_position - held.global_position) * 12.0
    held.angular_velocity = Vector3.ZERO


func _target() -> void:
    if seated or coffee_ui.visible:
        hud_prompt.text = ""
        return
    if held != null and not held.has_meta("cushion"):
        hud_prompt.text = Loc.t("p_drop")
        return
    ray.force_raycast_update()
    var txt := ""
    if ray.is_colliding():
        var c = ray.get_collider()
        if c != null and c.has_meta("kind"):
            match str(c.get_meta("kind")):
                "chair":
                    txt = Loc.t("p_sit") if int(c.get_meta("idx")) == MY_POD else Loc.f("p_talk", [WHO[int(c.get_meta("idx"))]])
                    if held != null and held.has_meta("cushion"):
                        txt = Loc.t("p_cushion")
                "phone":
                    var ph := int(c.get_meta("idx"))
                    if ph == MY_POD:
                        txt = Loc.t("p_answer")
                    elif bool(remote_ring.get(ph, false)):
                        txt = Loc.f("p_steal", [WHO[ph]])
                    else:
                        txt = Loc.t("p_console")
                "coffee":
                    txt = Loc.t("p_coffee")
                "vending":
                    txt = Loc.t("p_vending")
                "switch":
                    txt = Loc.t("p_switch")
                "altar":
                    txt = Loc.t("p_altar")
                "prop":
                    txt = Loc.t("p_pick") + str(c.get_meta("label"))
                "paper":
                    txt = Loc.t("p_paper")
                "radio":
                    txt = Loc.t("p_radio")
                "water":
                    txt = Loc.t("p_water")
                "bin":
                    txt = Loc.t("p_bin")
    hud_prompt.text = txt


# ------------------------------------------------------------- poste

func _sit() -> void:
    if chairride != null and chairride.riding:
        chairride._stop()
    if cushions.has(MY_POD):
        _fart_at(MY_POD, true)
        if Net.active:
            sync.bcast(&"action", ["fart", MY_POD])
    seated = true
    stand_pos = player.global_position
    player.global_position = seat_pos[MY_POD] + Vector3(0, 0.6, 0)
    player.rotation.y = float(pod_yaw[MY_POD]) + 0.34
    pitch = -0.06
    cam.rotation.x = pitch
    pc_ui.visible = true
    _update_status()
    _refresh_mouse()
    if in_call:
        pc_input.grab_focus()


func _stand() -> void:
    if not seated:
        return
    seated = false
    pc_ui.visible = false
    pc_input.release_focus()
    player.global_position = stand_pos
    _refresh_mouse()


func _update_status() -> void:
    var st := Loc.t("status") % [day, solved, quota, missed, int(expo), Game.wallet, _rank(), PODS]
    if in_call:
        var kind := str(cur_b.get("kind", ""))
        if kind == "conference":
            var o: Dictionary = cur_b["other"]
            st += "[" + Loc.t("tag_conf") + "]  " + Loc.f("st_conf", [str(cur_b["name"]), str(o["name"]), str(cur_b["relation"])])
            st += "\n" + Loc.f("st_profile", [str(cur_b["pers_label"]) + " / " + str(o["pers_label"]), str(cur_b["situation"])])
        else:
            if kind == "callback":
                st += "[" + Loc.t("tag_cb") + "]  "
            st += Loc.f("st_online", [call_human, int(cur_b["age"]), str(cur_b["place"])])
            st += "\n" + Loc.f("st_profile", [str(cur_b["pers_label"]), str(cur_b["situation"])])
    elif ringing:
        st += Loc.f("st_ringing", [int(ring_left)])
    else:
        st += Loc.t("st_free")
    st += Loc.t("st_goal")
    st += Loc.t("st_order") + _task_text()
    if api_key == "" and not relay_ok():
        st += Loc.t("st_offline")
    if missions != null:
        var ms: String = missions.status_text()
        if ms != "":
            st += "\n" + ms
    pc_status.text = st
    pc_conv.text = Loc.t("conv_label") % [conviction, ""]
    pc_conv_bar.value = conviction
    _update_video()
    if Game.mood == "wifi":
        pc_god.disabled = true
        pc_god.text = Loc.t("red_wifi")
    else:
        pc_god.disabled = not god_ready
        pc_god.text = Loc.t("btn_red") if god_ready else Loc.f("btn_red_cool", [int(god_cool)])
    pc_answer.disabled = not ringing or in_call
    pc_mg_btn.disabled = in_call or ringing or minigame.running
    pc_hang.disabled = not in_call
    pc_input.editable = in_call and not busy
    for i in pc_btns.size():
        var b: Button = pc_btns[i]
        b.disabled = not in_call or busy or (i < used_powers.size() and bool(used_powers[i]))


func _update_video() -> void:
    if pc_video == null:
        return
    var target := 0.0 if in_call else 0.22
    video_static = lerp(video_static, target, 0.08)
    (pc_video.material as ShaderMaterial).set_shader_parameter("static_amt", video_static)
    if my_video_quad != null:
        my_video_quad.visible = in_call
        screen_labels[MY_POD].visible = not in_call
    if in_call:
        var secs := int(t - call_t0)
        pc_rec.text = ("o REC  " if fmod(t, 1.0) < 0.6 else "  REC  ") + "%02d:%02d" % [int(secs / 60.0), secs % 60]
        pc_sig.text = "[|||| ]" if fmod(t, 3.0) > 0.2 else "[||   ]"
        pc_video_head.text = Loc.t("video_on")
        var kind := str(cur_b.get("kind", ""))
        var who := call_human
        if kind != "conference":
            who = Loc.f("call_info", [call_human, int(cur_b.get("age", 0)), str(cur_b.get("place", ""))])
        pc_tag.text = who + "\n" + str(cur_b.get("situation", ""))
        pc_tag.visible = true
    else:
        pc_rec.text = ""
        pc_sig.text = ""
        pc_tag.visible = false
        pc_video_head.text = Loc.t("video_ring") if ringing else Loc.t("video_off")


func _power_sound(id: String) -> void:
    Sfx.play("power", -6.0)
    match id:
        "frogs":
            Sfx.play("frogs", -2.0)
        "cat":
            Sfx.play("meow", -2.0)
        "smite":
            Sfx.play("thunder", -4.0)
        "sky", "dream", "jingle":
            Sfx.play("shimmer", -4.0)


func _start_minigame() -> void:
    if in_call or ringing or minigame == null or minigame.running:
        return
    minigame.start()


func _on_minigame_done(score: int) -> void:
    var gain := score * 3
    _money(gain)
    Sfx.play("score", -4.0)
    _log(Loc.t("log_system"), Loc.f("mg_done", [score, gain]), "#8affc0")


func _rank() -> int:
    var rk := 1
    for i in rivals.size():
        if i != MY_POD and int(rivals[i]) > Game.earned:
            rk += 1
    return rk


# ------------------------------------------------------------- appels

func _answer() -> void:
    if not ringing or in_call or frozen:
        return
    var lang := Loc.lang
    var b: Dictionary
    var r := Game.rng.randf()
    var cb = Game.pick_callback()
    if dev_kind == "conference":
        r = 0.3
        day = max(day, 2)
    if day >= 2 and cb != null and r < 0.22:
        b = Believers.make_callback(cb)
        _stat("callbacks")
    elif day >= 2 and r < 0.38:
        b = Believers.make_conference(lang, Game.rng)
        _stat("conferences")
    else:
        b = Believers.make(lang, Game.rng)
    # CONSEQUENCES : quelqu'un touche par un conseil divin appelle a son tour
    if not pending_calls.is_empty() and (randf() < 0.5 or str(pending_calls[0].get("kind", "")) == "cross"):
        b = pending_calls.pop_front()
    elif str(b.get("kind", "")) != "conference" and not (str(b.get("kind", "")) == "callback" and b.has("echo_id")):
        # REALITY ECHO : une idee dite par les joueurs contamine la priere
        var ec: Dictionary = Reality.pick_for_prayer()
        if not ec.is_empty():
            b = Reality.shape_believer(b, ec)
            if Net.active and not Net.is_host():
                sync.bcast(&"action", ["echo_used", {"id": int(ec["id"]), "name": str(b["name"])}])
    if viral != null:
        b = viral.maybe_viewer(b)
    if b.has("echo_first"):
        # PREMIER ECHO : ce fidele va citer mot pour mot ce qu'un joueur a dit
        fun.pop(cam.global_position - cam.global_transform.basis.z * 2.0 + Vector3(0, 0.5, 0), Loc.t("echo_first_call"), Color(0.45, 1.0, 0.7), 130)
        Sfx.play("glitch", -4.0)
        vignette.color = Color(0.3, 1.0, 0.5, 0.35)
    if b.has("echo_self"):
        # le personnage invente par les joueurs... appelle
        fun.pop(cam.global_position - cam.global_transform.basis.z * 2.0 + Vector3(0, 0.5, 0), Loc.f("echo_incoming", [str(b["name"]).to_upper()]), Color(0.45, 1.0, 0.7), 150)
        Sfx.play("glitch", -2.0)
        Sfx.play("god_speak", -6.0, 0.7)
        viral.highlight("echo_self")
    cur_b = b
    if str(b["kind"]) == "conference":
        var o: Dictionary = b["other"]
        call_human = str(b["name"]).split(" ")[0] + " & " + str(o["name"]).split(" ")[0]
    else:
        call_human = str(b["name"])
    call_motive = str(b["shame"])
    missions.offer()
    in_call = true
    ringing = false
    conviction = int(b["start"]) + (20 if Game.mood == "openhouse" else 0)
    hist = []
    call_lines = 0
    last_line = ""
    last_headline = ""
    used_powers = []
    for i in active_powers.size():
        used_powers.append(false)
    _stat("calls")
    call_t0 = t
    video_static = 1.0
    Sfx.stop("ring")
    Sfx.play("call_connect", -4.0)
    if callview != null:
        callview.start_call(b)
    _call_net("start", b)
    SteamNet.presence("call", call_human)
    pc_log.clear()
    screen_labels[MY_POD].text = Loc.f("scr_online", [call_human])
    var tag := ""
    if str(b["kind"]) == "conference":
        tag = "[" + Loc.t("tag_conf") + "] "
    elif str(b["kind"]) == "callback":
        tag = "[" + Loc.t("tag_cb") + "] "
    _log(Loc.t("log_call"), tag + Loc.f("call_info2", [call_human, int(b["age"]), str(b["place"]), str(b["pers_label"]), str(b["situation"])]), "#ffb84d")
    if not seated:
        _say(Loc.f("say_sit_call", [call_human]), 6.0)
    _ask_ai(Loc.f("mk_start", [call_human]))
    if seated:
        pc_input.grab_focus()


func _send_line(txt: String) -> void:
    txt = txt.strip_edges()
    if txt == "" or not in_call or busy:
        return
    pc_input.text = ""
    player_lines += 1
    missions.on_player_line(txt)
    var promised := false
    if api_key == "" and not relay_ok() and cur_b.get("promises", []).size() < 2:
        # hors ligne : les vraies promesses deviennent des « promesses de Dieu »
        var lowp := txt.to_lower()
        for kw in Loc.list("promise_words"):
            if lowp.contains(str(kw)):
                var plo: Array = cur_b.get("promises", [])
                plo.append(txt.substr(0, 120))
                cur_b["promises"] = plo
                echo_promise(txt.substr(0, 120), str(cur_b.get("name", "?")))
                promised = true
                break
    if not promised:
        echo_hear(txt, "call")
    _log(Loc.t("log_you"), txt, "#ffe6a8")
    _ask_ai(Loc.t("mk_employee") + txt)


func _use_power(i: int) -> void:
    if not in_call or busy or i >= active_powers.size():
        return
    if i < used_powers.size() and bool(used_powers[i]):
        _say(str(active_powers[i][0]) + " : " + Loc.t("power_used"), 2.0)
        return
    if i < used_powers.size():
        used_powers[i] = true
    used_help = true
    _stat("powers")
    _log(Loc.t("log_power"), Loc.f("log_power_on", [str(active_powers[i][0])]), "#8affc0")
    _add_expo(2.0)
    if callview != null:
        callview.power_fx(str(active_powers[i][2]))
    _call_net("fx", str(active_powers[i][2]))
    _power_sound(str(active_powers[i][2]))
    _ask_ai(EVENT_TAG + Loc.f("mk_event", [str(active_powers[i][1])]))


func _resolve() -> void:
    if not in_call:
        return
    in_call = false
    missions.end_call()
    if callview != null:
        callview.end_call(true)
    var conf := str(cur_b.get("kind", "")) == "conference"
    next_ring = t + _ring_delay(12.0)
    screen_labels[MY_POD].text = Loc.f("pod_label", [MY_POD + 1, WHO[MY_POD]])
    var sale: Array = SALES[randi() % SALES.size()]
    var mult := float(cur_b.get("bonus", 1.0))
    if Game.mood == "audit":
        mult *= 1.5
    elif Game.mood == "rush":
        mult *= 1.25
    if Game.has("sales"):
        mult *= 1.3
    var gain := int((int(sale[1]) + randi_range(-60, 160) + int(conviction) * 4) * mult)
    Sfx.play("sale", -3.0)
    var data := {"gain": gain, "sold": str(sale[0]), "b": cur_b, "headline": last_headline,
        "line": last_line, "who": call_human, "lines": call_lines, "conf": conf}
    if Net.active and not Net.is_host():
        sync.to_host(&"conversion", [data])
    else:
        net_conversion(data, Net.my_id())
    _call_net("end", null)
    _log(Loc.t("log_converted"), Loc.f("converted_log", [str(sale[0]), gain]), "#8affc0")
    fun.celebrate(MY_POD, true)
    if Net.active:
        sync.bcast(&"action", ["confetti", MY_POD])
    if cur_b.has("viewer"):
        viral.highlight("viewer", str(cur_b["viewer"]))
        Profile.unlock("viewer")
    Profile.count("conversions", 2 if conf else 1)
    if str(cur_b.get("pers", "")) == "kid":
        Profile.unlock("kid")
    if conf:
        Profile.unlock("conf")
    if str(cur_b.get("kind", "")) == "callback":
        Profile.unlock("callback")
    _say(Loc.f("converted_say", [str(sale[0]), gain, solved, quota]), 5.0)
    conviction = 0


func _press_red() -> void:
    if frozen:
        return
    if Game.mood == "wifi":
        _say(Loc.t("red_wifi"), 3.0)
        return
    if not god_ready:
        _say(Loc.t("red_hot"), 3.0)
        return
    god_ready = false
    god_cool = 25.0 if Game.has("turbo") else 45.0
    used_help = true
    _stat("red")
    Profile.count("red")
    if not in_call:
        _god(Loc.pick("red_idle"))
        _add_expo(2.0)
        return
    var verdict := randf()
    if verdict < 0.45:
        conviction = min(100, conviction + 35)
        _god(Loc.t("v_yes"))
        _log(Loc.t("log_god"), Loc.t("v_yes_log"), "#ffb84d")
        if callview != null:
            callview.power_fx("god_yes")
        _call_net("fx", "god_yes")
        Sfx.play("shimmer", -2.0)
        _ask_ai(EVENT_TAG + Loc.t("mk_god_yes"))
    elif verdict < 0.75:
        conviction = max(0, conviction - 20)
        _add_expo(4.0)
        _god(Loc.t("v_no"))
        _log(Loc.t("log_god"), Loc.t("v_no_log"), "#ff8888")
        if callview != null:
            callview.power_fx("god_no")
        _call_net("fx", "god_no")
        Sfx.play("thunder", -6.0)
        _ask_ai(Loc.t("mk_god_no"))
    else:
        _god(Loc.t("v_none"))
        _log(Loc.t("log_god"), Loc.t("v_none_log"), "#ffb84d")


func _hang_up() -> void:
    if not in_call:
        return
    in_call = false
    missions.end_call()
    video_static = 1.0
    Sfx.play("call_end", -6.0)
    if callview != null:
        callview.hang_up()
    _call_net("hang", null)
    next_ring = t + _ring_delay(8.0)
    _stat("hangups")
    screen_labels[MY_POD].text = Loc.f("pod_label", [MY_POD + 1, WHO[MY_POD]])
    _add_expo(4.0)
    _log(Loc.t("log_system"), Loc.t("hang_log"), "#ff8888")


# ------------------------------------------------------------- cafe

func _open_coffee() -> void:
    coffee_ui.visible = true
    _update_coffee()
    _refresh_mouse()


func _close_coffee() -> void:
    coffee_ui.visible = false
    _refresh_mouse()


func _update_coffee() -> void:
    var fmt: String = Loc.t("big") if cof_big else Loc.t("small")
    var mk: String = Loc.t("with") if cof_milk else Loc.t("without")
    var cmd: String = (Loc.t("cof_cmd") + _task_text()) if task_on else Loc.t("cof_nocmd")
    cof_lbl.text = Loc.f("cof_sel", [fmt, cof_sugar, mk, cmd])


func _set_sugar(n: int) -> void:
    cof_sugar = n
    _update_coffee()


func _toggle_milk() -> void:
    cof_milk = not cof_milk
    _update_coffee()


func _toggle_big() -> void:
    cof_big = not cof_big
    _update_coffee()


func _make_coffee() -> void:
    var p := player.global_position + Vector3(0, 0.6, 0) - player.global_transform.basis.z * 0.9
    var size: Vector3 = Vector3(0.15, 0.22, 0.15) if cof_big else Vector3(0.12, 0.15, 0.12)
    var rb := _prop(p, size, Color(0.93, 0.92, 0.9), 0.4, Loc.t("prop_coffee"), true)
    rb.set_meta("cup", true)
    rb.set_meta("sugar", cof_sugar)
    rb.set_meta("milk", cof_milk)
    rb.set_meta("big", cof_big)
    held = rb
    _close_coffee()
    Sfx.play_at("coffee", player.global_position, -4.0)
    _say(Loc.t("coffee_ready"), 5.0)


func _deliver() -> void:
    if held == null or not held.has_meta("cup"):
        _say(Loc.t("counter_wait"), 3.0)
        return
    var cup := held
    held = null
    var su := int(cup.get_meta("sugar"))
    var mi := bool(cup.get_meta("milk"))
    var bg := bool(cup.get_meta("big"))
    cup.queue_free()
    if Net.active and not Net.is_host():
        sync.to_host(&"coffee", [su, mi, bg])
        return
    _coffee_delivered(su, mi, bg, Net.my_id())


func _coffee_delivered(su: int, mi: bool, bg: bool, who: int) -> void:
    var ok: bool = task_on and su == task_sugar and mi == task_milk and bg == task_big
    if ok and coffee_salted:
        coffee_salted = false
        ok = false
        _god_all(Loc.t("god_salt"))
    var nm := ""
    if Net.active:
        nm = str(Net.players.get(who, {}).get("name", "")) + " : "
    if ok:
        task_on = false
        next_task = t + (25.0 if Game.mood == "hungry" else 70.0)
        _stat("coffee_ok")
        Profile.count("coffee_ok")
        if Game.mood == "hungry":
            _add_expo(-10.0)
            _money(150)
        else:
            _add_expo(-5.0)
        Sfx.play("sale", -8.0, 1.3)
        _god_all(nm + Loc.t("god_perfect"))
    elif task_on:
        _stat("coffee_bad")
        Sfx.play("error", -4.0)
        _add_expo(6.0)
        _god_all(nm + Loc.t("god_wrong"))
    elif who == Net.my_id():
        _say(Loc.t("no_order"), 3.0)


# ------------------------------------------------------------- entrees

func _physics_process(dt: float) -> void:
    if seated or frozen or paused:
        player.velocity = Vector3.ZERO
        return
    if chairride != null and chairride.riding:
        chairride.physics(dt)
        return
    var dir := Vector3.ZERO
    var b := player.global_transform.basis
    if Input.is_physical_key_pressed(KEY_W):
        dir -= b.z
    if Input.is_physical_key_pressed(KEY_S):
        dir += b.z
    if Input.is_physical_key_pressed(KEY_A):
        dir -= b.x
    if Input.is_physical_key_pressed(KEY_D):
        dir += b.x
    dir.y = 0.0
    dir = dir.normalized()
    if slip_t > 0.0:
        slip_t -= dt
        dir = -player.global_transform.basis.z
        cam.rotation.z = sin(slip_t * 9.0) * 0.5 * slip_t
        cam.position.y = 0.72 - (0.5 if slip_t < 1.0 else 0.0) * min(1.0, slip_t)
        if slip_t <= 0.0:
            cam.rotation.z = 0.0
    var running := Input.is_key_pressed(KEY_SHIFT) and dir.length() > 0.1
    var speed := 5.4 if running else 3.0
    player.velocity.x = dir.x * speed
    player.velocity.z = dir.z * speed
    var grav: float = (6.0 if Game.mood == "update" else 22.0) * (echo_world.gravity_scale() if echo_world != null else 1.0)
    if not player.is_on_floor():
        player.velocity.y -= grav * dt
    elif want_jump:
        player.velocity.y = 6.5 if Game.mood == "update" else 5.0
    else:
        player.velocity.y = -0.2
    want_jump = false
    player.move_and_slide()

    if dir.length() > 0.1:
        bob += dt * (12.0 if running else 7.0)
        cam.position.y = 0.72 + sin(bob) * (0.035 if running else 0.018)
        var ph := int(floor(bob / PI))
        if ph != step_phase and player.is_on_floor():
            step_phase = ph
            Sfx.play("step%d" % (randi() % 4), -13.0 if not running else -9.0, randf_range(0.9, 1.1))

    if rule != "" and rule_left < 35.0:
        if rule_kind == "run" and running:
            _break_rule(Loc.t("why_run"))
        elif rule_kind == "stay" and player.global_position.distance_to(rule_spot) > 6.5:
            _break_rule(Loc.t("why_stay"))
        elif rule_kind == "dark" and lights_on:
            _break_rule(Loc.t("why_dark"))


func _unhandled_input(e: InputEvent) -> void:
    if overlay != null and overlay.is_open():
        if e is InputEventKey and e.pressed and not e.echo and (e.keycode == KEY_ENTER or e.keycode == KEY_KP_ENTER):
            if overlay.mode == "intro" and Net.is_host() and (not Net.active or Net.all_loaded()):
                get_viewport().set_input_as_handled()
                _on_start_shift()
        return
    if frozen:
        return
    if e is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        var ms := 0.0028 * Loc.sens
        player.rotate_y(-e.relative.x * ms)
        pitch = clampf(pitch - e.relative.y * ms * (-1.0 if Loc.invert_y else 1.0), -1.45, 1.45)
        cam.rotation.x = pitch
    elif e is InputEventMouseButton and e.pressed and not seated and not coffee_ui.visible:
        if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        elif e.button_index == MOUSE_BUTTON_RIGHT and held != null and held.has_meta("chicken"):
            fun.squeeze(held.global_position)
        elif e.button_index == MOUSE_BUTTON_LEFT and held != null:
            var obj := held
            held = null
            obj.linear_velocity = Vector3.ZERO
            var aim: Vector3 = fun.aim_velocity(obj.global_position, -cam.global_transform.basis.z, 14.0)
            if aim != Vector3.ZERO:
                obj.linear_velocity = aim
            else:
                obj.apply_central_impulse(-cam.global_transform.basis.z * 9.0 + Vector3.UP * 1.5)
            if not obj.has_meta("chicken"):
                fun.thrown(obj)
            Sfx.play("swish", -8.0, 1.3)
            if obj.has_meta("cup"):
                get_tree().create_timer(1.3).timeout.connect(_spill.bind(obj))
            if obj.has_meta("chicken"):
                fun.thrown(obj)
                Sfx.play_at("squeak", obj.global_position, -4.0, 1.3)
            if rule_kind == "throw":
                _break_rule(Loc.t("why_throw"))
    elif e is InputEventKey and e.pressed and not e.echo:
        if seated and pc_input.has_focus() and e.keycode != KEY_ESCAPE:
            return
        if chat_edit != null and chat_edit.has_focus():
            if e.keycode == KEY_ESCAPE:
                chat_edit.visible = false
                chat_edit.release_focus()
                _refresh_mouse()
            return
        match e.keycode:
            KEY_ESCAPE:
                if seated:
                    _stand()
                elif coffee_ui.visible:
                    _close_coffee()
                else:
                    _pause()
            KEY_E:
                _interact()
            KEY_X:
                fun.try_slap()
            KEY_R:
                chairride.toggle()
            KEY_1, KEY_KP_1, KEY_2, KEY_KP_2, KEY_3, KEY_KP_3, KEY_4, KEY_KP_4, KEY_5, KEY_KP_5, KEY_6, KEY_KP_6, KEY_7, KEY_KP_7, KEY_8, KEY_KP_8, KEY_9, KEY_KP_9:
                var num := 0
                for k in [[KEY_1, KEY_KP_1], [KEY_2, KEY_KP_2], [KEY_3, KEY_KP_3], [KEY_4, KEY_KP_4], [KEY_5, KEY_KP_5], [KEY_6, KEY_KP_6], [KEY_7, KEY_KP_7], [KEY_8, KEY_KP_8], [KEY_9, KEY_KP_9]]:
                    if e.keycode in k:
                        break
                    num += 1
                if seated or in_call:
                    _use_power(num)
                elif num < EMOTES.size():
                    _do_emote(EMOTES[num])
            KEY_H, KEY_J, KEY_K:
                if Net.i_am_satan():
                    _sabotage({KEY_H: "blackout", KEY_J: "salt", KEY_K: "leak"}[e.keycode])
            KEY_F:
                flash_on = not flash_on
                _say(Loc.t("flash_on") if flash_on else Loc.t("flash_off"), 1.5)
            KEY_F2:
                if outline_node != null:
                    outline_node.visible = not outline_node.visible
            KEY_F12:
                _photo()
            KEY_T, KEY_ENTER:
                if Net.active and not seated:
                    _open_chat()
            KEY_G:
                _press_red()
            KEY_SPACE:
                if ringing:
                    _answer()
                elif not seated:
                    want_jump = true


func _interact() -> void:
    if seated:
        _stand()
        return
    if coffee_ui.visible:
        _close_coffee()
        return
    ray.force_raycast_update()
    var c = ray.get_collider() if ray.is_colliding() else null
    if held != null:
        if c != null and c.has_meta("kind") and str(c.get_meta("kind")) == "altar":
            _deliver()
        elif c != null and c.has_meta("kind") and str(c.get_meta("kind")) == "chair" and held.has_meta("cushion"):
            var cpod := int(c.get_meta("idx"))
            var cu := held
            held = null
            cu.queue_free()
            _place_cushion(cpod)
            if Net.active:
                sync.bcast(&"action", ["cushion", cpod])
            Sfx.play("boing", -8.0, 1.4)
            _say(Loc.t("cushion_placed"), 3.0)
        else:
            held = null
        return
    if c == null or not c.has_meta("kind"):
        return
    match str(c.get_meta("kind")):
        "chair", "phone":
            if int(c.get_meta("idx")) == MY_POD:
                _sit()
            elif str(c.get_meta("kind")) == "phone" and bool(remote_ring.get(int(c.get_meta("idx")), false)):
                _steal_call(int(c.get_meta("idx")))
            elif str(c.get_meta("kind")) == "chair":
                _talk_to(int(c.get_meta("idx")))
            else:
                _say(Loc.t("not_yours"), 3.0)
        "paper":
            var pp := player.global_position + Vector3(0, 0.6, 0) - player.global_transform.basis.z * 0.8
            held = _prop(pp, Vector3(0.14, 0.14, 0.14), Color(0.92, 0.9, 0.84), 0.12, Loc.t("prop_ball"))
            Sfx.play("paper_hit", -6.0, 1.4)
            _say(Loc.t("paper_hint"), 3.0)
        "radio":
            _radio_next()
        "water":
            if t > water_cd:
                water_cd = t + 60.0
                _add_expo(-4.0)
                Sfx.play("swish", -6.0, 0.6)
                if not viral.try_voice_item("water"):
                    _say(Loc.t("water_drink"), 3.0)
            else:
                _say(Loc.t("water_wait"), 2.0)
        "prop":
            held = c
            delivery.picked(c)
        "coffee":
            _open_coffee()
        "vending":
            var p := player.global_position + Vector3(0, 0.6, 0) - player.global_transform.basis.z * 0.9
            var roll_v := randf()
            if roll_v < 0.3:
                held = fun.make_chicken(p)
                Sfx.play("squeak", -6.0)
                _say(Loc.t("chicken_got"), 4.0)
            elif roll_v < 0.6:
                held = _prop(p, Vector3(0.3, 0.07, 0.3), Color(1.0, 0.45, 0.65), 0.2, Loc.t("prop_cushion"))
                held.set_meta("cushion", true)
                Sfx.play("fart", -14.0, 1.6)
                _say(Loc.t("cushion_got"), 4.0)
            else:
                held = _prop(p, Vector3(0.2, 0.06, 0.13), Color(0.95, 0.6, 0.15), 0.3, Loc.t("prop_snack"))
                if not viral.try_voice_item("vending"):
                    _say(Loc.t("snack_ok"), 3.0)
        "switch":
            lights_on = not lights_on
            Sfx.play("power_up" if lights_on else "power_down", -6.0)
            _say(Loc.t("lights_on") if lights_on else Loc.t("lights_off"), 2.5)
        "altar":
            _say(Loc.t("counter_wait"), 3.0)


# ------------------------------------------------------------- photo + chat texte

var chat_edit: LineEdit


func _photo() -> void:
    await RenderingServer.frame_post_draw
    var img := get_viewport().get_texture().get_image()
    DirAccess.make_dir_recursive_absolute("user://photos")
    var path := "user://photos/omg_%s.png" % Time.get_datetime_string_from_system().replace(":", "-")
    img.save_png(path)
    Sfx.play("ui_click", -2.0, 0.5)
    _say(Loc.f("photo_saved", [ProjectSettings.globalize_path(path)]), 4.0)


func _open_chat() -> void:
    if chat_edit == null:
        chat_edit = LineEdit.new()
        chat_edit.anchor_left = 0.5
        chat_edit.anchor_right = 0.5
        chat_edit.anchor_top = 1.0
        chat_edit.anchor_bottom = 1.0
        chat_edit.offset_left = -400
        chat_edit.offset_right = 400
        chat_edit.offset_top = -170
        chat_edit.offset_bottom = -128
        chat_edit.placeholder_text = Loc.t("chat_hint")
        chat_edit.add_theme_font_override("font", Loc.font("bold"))
        chat_edit.add_theme_font_size_override("font_size", 18)
        chat_edit.max_length = 90
        chat_edit.text_submitted.connect(_send_chat)
        hud_layer.add_child(chat_edit)
    chat_edit.visible = true
    chat_edit.text = ""
    chat_edit.grab_focus()
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _send_chat(txt: String) -> void:
    txt = txt.strip_edges()
    chat_edit.visible = false
    chat_edit.release_focus()
    _refresh_mouse()
    if txt == "":
        return
    sync.bcast(&"action", ["chat", txt])
    _say(WHO[MY_POD] + " : " + txt, 5.0)
    echo_hear(txt, "chat")


# ------------------------------------------------------------- fou rire

func _do_emote(em: String) -> void:
    if emote_t > 0.0:
        return
    if fp_hands != null:
        fp_hands.wave()
    if mass_left > 0.0:
        fun.danced = true
    cur_emote = em
    emote_t = 2.6
    Sfx.play(str(EMOTE_SFX.get(em, "boing")), -6.0)
    _say(Loc.t("emote_" + em), 1.5)
    # les collegues proches reagissent
    for d in npcs:
        var hold: Node3D = d["hold"]
        if hold.global_position.distance_to(player.global_position) < 5.0 and float(d["say"]) <= 0.0:
            var c = d["char"]
            var bub: Label3D = d["bub"]
            bub.text = Loc.pick("cw_react_" + ("laugh" if em in ["dance", "laugh", "flex", "wave"] else "meh"))
            d["say"] = 3.5
            c.say(1.5)
            c.set_emotion("laugh" if em in ["dance", "laugh", "flex"] else "dizzy")


func _spill(cup_v: Variant) -> void:
    # le cafe lance finit en flaque glissante
    if not is_instance_valid(cup_v):
        return
    var cup: RigidBody3D = cup_v
    var pos := cup.global_position
    cup.queue_free()
    _make_puddle(Vector3(pos.x, 0.02, pos.z))
    if Net.active:
        sync.bcast(&"action", ["puddle", Vector3(pos.x, 0.02, pos.z)])


func _make_puddle(pos: Vector3) -> void:
    Sfx.play_at("paper_hit", pos, -4.0, 0.6)
    var m := MeshInstance3D.new()
    var cm := CylinderMesh.new()
    cm.top_radius = 0.7
    cm.bottom_radius = 0.7
    cm.height = 0.01
    m.mesh = cm
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.25, 0.14, 0.06)
    mat.roughness = 0.05
    mat.metallic = 0.3
    m.material_override = mat
    m.scale = Vector3(1.0, 1.0, randf_range(0.6, 1.0))
    add_child(m)
    m.global_position = pos
    var a := Area3D.new()
    var cs := CollisionShape3D.new()
    var sh := CylinderShape3D.new()
    sh.radius = 0.65
    sh.height = 1.0
    cs.shape = sh
    a.add_child(cs)
    m.add_child(a)
    a.body_entered.connect(_on_puddle)
    get_tree().create_timer(45.0).timeout.connect(m.queue_free)


func _on_puddle(body: Node) -> void:
    if body != player or seated or slip_t > 0.0:
        return
    slip_t = 1.4
    Sfx.play("whistle_down", -4.0)
    get_tree().create_timer(0.7).timeout.connect(Sfx.play.bind("boing", -4.0, 0.8))
    fun.pop(cam.global_position - cam.global_transform.basis.z * 1.3, Loc.pick("pop_slip"), Color(0.4, 0.9, 1.0), 150)
    _stat("slips")
    if Net.active:
        sync.bcast(&"action", ["slip", 0])
    Profile.unlock("slip")
    viral.highlight("slips")
    cur_emote = "facepalm"
    emote_t = 1.5
    _say(Loc.pick("slip_lines"), 2.5)


func _place_cushion(pod: int) -> void:
    if cushions.has(pod):
        return
    var m := MeshInstance3D.new()
    var sm := SphereMesh.new()
    sm.radius = 0.2
    sm.height = 0.12
    m.mesh = sm
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(1.0, 0.45, 0.65)
    mat.roughness = 0.3
    m.material_override = mat
    add_child(m)
    var sp: Vector3 = seat_pos[pod]
    m.global_position = sp + Vector3(0, 0.6, 0)
    cushions[pod] = m


func _fart_at(pod: int, me: bool) -> void:
    if not cushions.has(pod):
        return
    var m: Node3D = cushions[pod]
    cushions.erase(pod)
    var pos := m.global_position
    m.queue_free()
    Sfx.play_at("fart", pos, 2.0)
    fun.pop(pos + Vector3(0, 1.0, 0), Loc.pick("pop_fart"), Color(0.55, 0.85, 0.3), 150)
    get_tree().create_timer(0.9).timeout.connect(Sfx.play_at.bind("laugh", pos + Vector3(0, 1, 0), -6.0, 1.0))
    _stat("farts")
    Profile.unlock("fart")
    viral.highlight("farts")
    if me:
        cam_shake = 0.6
        _say(Loc.t("fart_me"), 4.0)
    # la victime et les collegues reagissent
    for d in npcs:
        var c = d["char"]
        var hold: Node3D = d["hold"]
        var dist := hold.global_position.distance_to(pos)
        if int(d["pod"]) == pod:
            c.set_emotion("fury")
            (d["bub"] as Label3D).text = Loc.pick("cw_farted")
            d["say"] = 5.0
        elif dist < 9.0:
            c.set_emotion("laugh")
            c.say(1.5)
    if Net.is_host():
        _god_all(Loc.pick("god_fart"))


func _steal_call(pod: int) -> void:
    if ringing or in_call or not Net.active:
        return
    remote_ring[pod] = false
    sync.bcast(&"action", ["steal", pod])
    ringing = true
    ring_left = 30.0
    Sfx.loop_at("ring", "phone_ring", ring_spot, -2.0)
    Sfx.play("whistle_up", -6.0)
    _stat("steals")
    Profile.unlock("thief")
    viral.highlight("steals")
    _say(Loc.f("call_steal_ok", [WHO[pod]]), 4.0)


func _mass(dt: float) -> void:
    # MESSE OBLIGATOIRE : tout le monde doit courir a l'autel
    if mass_left > 0.0:
        mass_left -= dt
        if mass_left <= 0.0:
            _end_mass()
        return
    next_mass -= dt
    if next_mass <= 0.0 and not in_call and Game.SHIFT_SECONDS - shift_left > 60.0 and shift_left > 40.0:
        next_mass = randf_range(170.0, 260.0)
        mass_left = 20.0
        mass_disco = randf() < (0.95 if Dev.args.has("disco") else 0.4)
        fun.danced = false
        for aid in avatars:
            avatars[aid]["danced"] = false
        Sfx.play("choir", -6.0)
        _god_all(Loc.t("god_mass_disco") if mass_disco else Loc.t("god_mass"))
        get_tree().create_timer(14.0).timeout.connect(viral.highlight.bind("mass"))


func _end_mass() -> void:
    var missing := []
    var inside := Vector2(player.global_position.x, player.global_position.z).length() < 5.6
    if inside:
        Profile.unlock("mass")
    if not inside or (mass_disco and not fun.danced):
        missing.append(WHO[MY_POD])
    for id in avatars:
        var d: Dictionary = avatars[id]
        var ap: Vector3 = d["pos"]
        if Vector2(ap.x, ap.z).length() >= 5.6 or bool(d["seated"]) or (mass_disco and not bool(d.get("danced", false))):
            missing.append(str(Net.players.get(id, {}).get("name", "?")))
    if mass_disco and missing.is_empty():
        Profile.unlock("disco")
    if missing.is_empty():
        _add_expo(-15.0)
        _money(80 * Net.count())
        _god_all(Loc.t("god_mass_ok"))
        net_fx_event("cheer", null)
        if Net.active:
            sync.bcast(&"fx_event", ["cheer", null])
    else:
        _add_expo(6.0 * float(missing.size()))
        _god_all(Loc.f("god_mass_fail", [", ".join(missing)]))


func _sabotage(kind: String) -> void:
    if float(sabotage_cd.get(kind, 0.0)) > t:
        _say(Loc.f("satan_cd", [int(float(sabotage_cd[kind]) - t)]), 2.0)
        return
    sabotage_cd[kind] = t + 90.0
    _say(Loc.t("satan_done_" + kind), 3.0)
    Sfx.play("whistle_down", -10.0)
    if Net.is_host():
        _do_sabotage(kind)
    else:
        sync.to_host(&"action", ["sabotage", kind])


func _do_sabotage(kind: String) -> void:
    match kind:
        "blackout":
            lights_on = false
            blackout_left = 10.0
            Sfx.play("power_down", -2.0)
            _god_all(Loc.t("god_blackout_sab"))
        "salt":
            coffee_salted = true
        "leak":
            _add_expo(12.0)
            _god_all(Loc.t("god_leak"))


func net_vote(target: int) -> void:
    if Net.is_host():
        _register_vote(Net.my_id(), target)
    else:
        sync.to_host(&"action", ["vote", target])


func _register_vote(voter: int, target: int) -> void:
    votes[voter] = target
    if votes.size() >= Net.players.size():
        var tally := {}
        for v in votes.values():
            tally[v] = int(tally.get(v, 0)) + 1
        var best := -1
        var best_n := 0
        for k in tally:
            if int(tally[k]) > best_n:
                best_n = int(tally[k])
                best = int(k)
        var satan_id := -1
        for id in Net.players:
            if Net.is_satan(int(id)):
                satan_id = int(id)
        var res := {"caught": best == satan_id, "satan": str(Net.players.get(satan_id, {}).get("name", "?")),
            "accused": str(Net.players.get(best, {}).get("name", "?"))}
        overlay.show_vote_result(res)
        sync.bcast(&"action", ["vote_result", res])


# ------------------------------------------------------------- co-op en ligne

func _is_player_pod(i: int) -> bool:
    if not Net.active:
        return false
    for id in Net.players:
        if int(Net.players[id]["pod"]) == i:
            return true
    return false


func _stat(key: String, n := 1) -> void:
    if Net.active and not Net.is_host():
        sync.to_host(&"stat", [key, n])
        return
    Game.stats[key] = int(Game.stats.get(key, 0)) + n


func _money(v: int) -> void:
    if Net.active and not Net.is_host():
        sync.to_host(&"money", [v])
        return
    Game.add_money(v)
    money = Game.earned


func _god_all(text: String) -> void:
    _god(text)
    if Net.active and Net.is_host() and sync != null:
        sync.bcast(&"god", [text])


func _call_net(kind: String, data: Variant) -> void:
    if Net.active and sync != null:
        sync.bcast(&"call_event", [kind, data])


func _on_net_status(text: String) -> void:
    _say(text, 4.0)


func _shake_tick(dt: float) -> void:
    if cam_shake > 0.0:
        cam_shake = max(0.0, cam_shake - dt)
        cam.h_offset = randf_range(-1, 1) * cam_shake * 0.06
        cam.v_offset = randf_range(-1, 1) * cam_shake * 0.06
    else:
        cam.h_offset = 0.0
        cam.v_offset = 0.0


func _rules_client() -> void:
    # les regles viennent de l'hote ; on note ou on etait quand elle a commence
    if rule != rule_seen:
        rule_seen = rule
        rule_spot = player.global_position
    var extra := ""
    if task_on:
        extra = Loc.t("order_head") + _task_text()
    if rule == "":
        hud_rule.text = extra.strip_edges()
    else:
        hud_rule.text = Loc.f("rule_head", [rule, int(max(0.0, rule_left)), extra])


func net_conversion(data: Dictionary, who: int) -> void:
    var conf := bool(data.get("conf", false))
    solved += 2 if conf else 1
    Game.add_money(int(data["gain"]))
    money = Game.earned
    Game.today.append({"b": data["b"], "sold": str(data["sold"]), "headline": str(data.get("headline", ""))})
    _stat("conversions", 2 if conf else 1)
    Game.stats["longest"] = max(int(Game.stats.get("longest", 0)), int(data.get("lines", 0)))
    var vb: Dictionary = data["b"]
    Reality.believer_convinced(vb)
    if vb.has("viewer"):
        var vl: Array = Game.stats.get("viewers", [])
        vl.append(str(vb["viewer"]))
        Game.stats["viewers"] = vl
    var sold: Array = Game.stats["sold"]
    sold.append(str(data["sold"]))
    if str(data.get("line", "")) != "":
        Game.note_quote(str(data["line"]), str(data.get("who", "")), int(data.get("lines", 0)))
    var seller: String = str(WHO[MY_POD]) if not Net.active else str(Net.players.get(who, {}).get("name", "?"))
    var bp: Dictionary = Game.stats.get("by_player", {})
    bp[seller] = int(bp.get(seller, 0)) + int(data["gain"])
    Game.stats["by_player"] = bp
    var dgain: Dictionary = Game.stats.get("day_gain", {})
    dgain[seller] = int(dgain.get(seller, 0)) + int(data["gain"])
    Game.stats["day_gain"] = dgain
    _update_board(false)
    if Net.active and who != Net.my_id():
        var nm := str(Net.players.get(who, {}).get("name", "?"))
        var txt := Loc.f("net_conv", [nm, str(data["sold"]), int(data["gain"])])
        net_fx_event("say", txt)
        sync.bcast(&"fx_event", ["say", txt])
    if solved >= quota and not quota_warned:
        quota_warned = true
        _god_all(Loc.t("quota_done"))


func net_state() -> Dictionary:
    return {"day": day, "shift": shift_left, "solved": solved, "quota": quota, "expo": expo,
        "madness": madness, "strikes": Game.strikes, "earned": Game.earned, "wallet": Game.wallet,
        "owned": Game.owned, "mood": Game.mood, "rule": rule, "rule_kind": rule_kind, "rule_left": rule_left,
        "task_on": task_on, "ts": task_sugar, "tm": task_milk, "tb": task_big, "tl": task_left,
        "lights": lights_on, "rivals": rivals, "mass": mass_left, "disco": mass_disco, "intern": intern.state() if intern != null else []}


func net_apply_state(st: Dictionary) -> void:
    if Net.is_host():
        return
    if not frozen:
        shift_left = float(st["shift"])
    solved = int(st["solved"])
    quota = int(st["quota"])
    expo = float(st["expo"])
    madness = float(st["madness"])
    Game.strikes = int(st["strikes"])
    Game.earned = int(st["earned"])
    Game.wallet = int(st["wallet"])
    Game.owned = st["owned"]
    money = Game.earned
    rule = str(st["rule"])
    rule_kind = str(st["rule_kind"])
    rule_left = float(st["rule_left"])
    var was_task := task_on
    task_on = bool(st["task_on"])
    task_sugar = int(st["ts"])
    task_milk = bool(st["tm"])
    task_big = bool(st["tb"])
    task_left = float(st["tl"])
    if task_on and not was_task:
        Sfx.play("ui_click", -6.0, 0.7)
    lights_on = bool(st["lights"])
    var ml := float(st.get("mass", 0.0))
    if ml > 0.0 and mass_left <= 0.0:
        Sfx.play("choir", -6.0)
    mass_left = ml
    mass_disco = bool(st.get("disco", false))
    if intern != null:
        intern.apply_state(st.get("intern", []))
    rivals = st["rivals"]
    rivals[MY_POD] = Game.earned


func net_end_shift(info: Dictionary) -> void:
    _end_shift_local()
    Game.strikes = int(info["strikes"])
    Game.earned = int(info["earned"])
    Game.wallet = int(info["wallet"])
    Game.owned = info["owned"]
    Game.fired = bool(info["fired"])
    Game.finished = bool(info["finished"])
    Game.stats = info["stats"]
    Game.best_quote = info["best_quote"]
    Game.converted = info["converted"]
    Game.gazette = info["gazette"]
    solved = int(info["solved"])
    quota = int(info["quota"])
    var res := str(info["res"])
    if res == "fired" or res == "week_done":
        overlay.show_review(bool(info["record"]))
    else:
        overlay.show_end(res, solved, quota)
    _refresh_mouse()


func net_next_day(info: Dictionary) -> void:
    overlay.close()
    paused = false
    Game.day = int(info["day"])
    Game.mood = str(info["mood"])
    Game.gazette = info["gazette"]
    Game.strikes = int(info["strikes"])
    _begin_day()


func net_again(sd: int) -> void:
    Game.new_run(Game.weekly, sd)
    Sfx.stop_all()
    get_tree().reload_current_scene()


func net_fx_event(kind: String, data: Variant) -> void:
    match kind:
        "sneeze":
            cam_shake = 0.8
            Sfx.play("thunder", -10.0, 1.4)
        "recompile":
            _recompile_pod(int(data))
        "say":
            _say(str(data), 4.0)
            Sfx.play("sale", -14.0, 1.5)
        "echo":
            if echoes != null:
                echoes.play_echo(data)
        "cheer":
            Sfx.play("cheer", -4.0)
            for d in npcs:
                d["char"].emote(["dance", "flex", "wave"][randi() % 3])


func request_buy(id: String) -> void:
    if Net.active and not Net.is_host():
        sync.to_host(&"buy", [id])
    else:
        Game.buy(id)


func net_my_pose() -> Dictionary:
    return {"pos": player.global_position, "yaw": player.rotation.y, "pitch": pitch, "seated": seated,
        "ring": ringing, "talk": voice_level, "emote": cur_emote, "ride": chairride != null and chairride.riding}


func _ensure_avatar(id: int) -> Dictionary:
    if avatars.has(id):
        return avatars[id]
    if not Net.players.has(id):
        return {}
    var pl: Dictionary = Net.players[id]
    var hold := Node3D.new()
    add_child(hold)
    var rng := RandomNumberGenerator.new()
    rng.seed = int(pl["seed"])
    var lk := Character.random_look(rng, {"age": rng.randi_range(22, 55)})
    lk["headset"] = true
    lk["badge"] = true
    lk = Profile.apply(lk, pl.get("cos", {}))
    var c := Character.new()
    hold.add_child(c)
    c.build(lk, "stand")
    c.position = Vector3(0, 0.78 * float(lk.get("height", 1.0)), 0)
    var lbl := _txt(hold, Vector3(0, 2.15, 0), str(pl["name"]), 34, Color(1.0, 0.75, 0.35), 0.0, true)
    lbl.outline_size = 10
    lbl.outline_modulate = Color(0, 0, 0, 0.9)
    lbl.no_depth_test = true
    var d := {"hold": hold, "char": c, "look": lk, "pos": Vector3.ZERO, "yaw": 0.0, "pitch": 0.0,
        "seated": false, "pod": int(pl["pod"]), "lbl": lbl, "last": t, "talk": 0.0, "first": true, "emote": ""}
    avatars[id] = d
    var vp := AudioStreamPlayer3D.new()
    var gen := AudioStreamGenerator.new()
    gen.mix_rate = 11025.0
    gen.buffer_length = 0.5
    vp.stream = gen
    vp.unit_size = 3.0
    vp.max_distance = 22.0
    vp.position = Vector3(0, 1.6, 0)
    vp.bus = "Voice"
    hold.add_child(vp)
    vp.play()
    d["voice"] = vp
    return d


func net_pose(id: int, p: Dictionary) -> void:
    var d := _ensure_avatar(id)
    if d.is_empty():
        return
    d["pos"] = p["pos"]
    d["yaw"] = float(p["yaw"])
    d["pitch"] = float(p["pitch"])
    d["talk"] = float(p.get("talk", 0.0))
    d["last"] = t
    remote_ring[int(d["pod"])] = bool(p.get("ring", false))
    var ride := bool(p.get("ride", false))
    if ride != (d.get("chair", null) != null):
        if ride:
            var ch: Node3D = ChairRide.make_chair()
            (d["hold"] as Node3D).add_child(ch)
            ch.position = Vector3(0, 0.35, 0)
            d["chair"] = ch
        else:
            (d["chair"] as Node3D).queue_free()
            d["chair"] = null
    var em := str(p.get("emote", ""))
    if em != "" and mass_left > 0.0:
        d["danced"] = true
    if em != str(d["emote"]):
        d["emote"] = em
        if em != "":
            _avatar_emote(d, em)
    var st := bool(p["seated"])
    if st != bool(d["seated"]) or bool(d["first"]):
        d["first"] = false
        d["seated"] = st
        var c = d["char"]
        var hold: Node3D = d["hold"]
        if st:
            var pod: int = int(d["pod"])
            hold.position = seat_pos[pod]
            hold.rotation.y = float(pod_yaw[pod])
            c.build(d["look"], "sit")
            c.position = Vector3(0, 0.6, -0.1)
            c.typing = true
        else:
            c.build(d["look"], "stand")
            c.position = Vector3(0, 0.78 * float(d["look"].get("height", 1.0)), 0)
            hold.position = Vector3(p["pos"].x, p["pos"].y - 0.92, p["pos"].z)


func _tick_avatars(dt: float) -> void:
    if not Net.active:
        return
    for id in avatars.keys():
        var d: Dictionary = avatars[id]
        if not Net.players.has(id):
            (d["hold"] as Node3D).queue_free()
            avatars.erase(id)
            continue
        var hold: Node3D = d["hold"]
        var c = d["char"]
        if not bool(d["seated"]):
            var target: Vector3 = d["pos"] - Vector3(0, 0.92, 0)
            var before := hold.position
            hold.position = hold.position.lerp(target, clamp(dt * 12.0, 0.0, 1.0))
            hold.rotation.y = lerp_angle(hold.rotation.y, float(d["yaw"]), clamp(dt * 12.0, 0.0, 1.0))
            var spd: float = Vector2(hold.position.x - before.x, hold.position.z - before.z).length() / maxf(dt, 0.001)
            c.walking = spd > 0.4
            var fwd := Vector3(-sin(float(d["yaw"])), sin(float(d["pitch"])), -cos(float(d["yaw"])))
            c.look_point = hold.global_position + Vector3(0, 1.5, 0) + fwd * 4.0
        else:
            c.look_point = Vector3.ZERO
        if float(d["talk"]) > 0.04:
            c.say(0.12)


func net_call_event(id: int, kind: String, data: Variant) -> void:
    if not Net.players.has(id):
        return
    var pod := int(Net.players[id]["pod"])
    var quad: MeshInstance3D = pod_video_quads.get(pod, null)
    if quad == null:
        return
    var cv = remote_cv.get(id, null)
    if cv == null:
        cv = CallView.new()
        cv.size = Vector2i(320, 240)
        add_child(cv)
        remote_cv[id] = cv
        var vm := StandardMaterial3D.new()
        vm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
        vm.albedo_texture = cv.get_texture()
        quad.material_override = vm
    match kind:
        "start":
            cv.start_call(data)
            quad.visible = true
            screen_labels[pod].visible = false
        "line":
            cv.line(str(data["text"]))
            cv.set_conviction(int(data["conv"]))
        "conv":
            cv.set_conviction(int(data["conv"]))
        "fx":
            cv.power_fx(str(data))
        "end", "hang":
            if kind == "end":
                cv.end_call(true)
            else:
                cv.hang_up()
            get_tree().create_timer(2.8).timeout.connect(_hide_call_quad.bind(quad.get_instance_id(), pod))


func _hide_call_quad(qid: int, pod: int) -> void:
    var q = instance_from_id(qid)
    if q != null and is_instance_valid(q):
        (q as Node3D).visible = false
        screen_labels[pod].visible = true


func _reset_label(lid: int, txt: String) -> void:
    var l = instance_from_id(lid)
    if l != null and is_instance_valid(l):
        (l as Label3D).text = txt


func net_emote(id: int, em: String) -> void:
    var d := _ensure_avatar(id)
    if not d.is_empty():
        _avatar_emote(d, em)


func net_action(id: int, kind: String, data: Variant) -> void:
    match kind:
        "chat":
            var nm := str(Net.players.get(id, {}).get("name", "?"))
            _say(nm + " : " + str(data), 6.0)
            Sfx.play("ui_click", -8.0, 1.6)
            var d := _ensure_avatar(id)
            if not d.is_empty():
                var lb: Label3D = d["lbl"]
                lb.text = nm + "\n\"" + str(data) + "\""
                get_tree().create_timer(6.0).timeout.connect(_reset_label.bind(lb.get_instance_id(), nm))
        "slap":
            fun.net_slap(id, data)
            var sw := _ensure_avatar(id)
            if not sw.is_empty():
                sw["char"].swing()
        "slip":
            var sd2 := _ensure_avatar(id)
            if not sd2.is_empty():
                sd2["char"].fall()
                Sfx.play_at("whistle_down", (sd2["hold"] as Node3D).global_position, -2.0)
                fun.pop((sd2["hold"] as Node3D).global_position + Vector3(0, 1.6, 0), Loc.pick("pop_slip"), Color(0.4, 0.9, 1.0))
        "squeak":
            fun.net_squeak(data)
        "bonk":
            fun.net_bonk(data)
        "confetti":
            fun.celebrate(int(data), false)
        "intern":
            intern.net_event(data)
        "echo_hear":
            if Net.is_host():
                var ewho := str(data.get("who", ""))
                Reality.hear(str(data["t"]), ewho if ewho != "" else str(Net.players.get(id, {}).get("name", "?")), str(data["ctx"]))
        "echo_first":
            if echo_world != null:
                echo_world.show_first(str(data.get("q", "")), str(data.get("who", "")))
        "echo_used":
            if Net.is_host():
                Reality.mark_used(int(data.get("id", -1)), str(data.get("name", "?")))
        "echo_promise":
            if Net.is_host():
                Reality.add_promise(str(data["t"]), str(Net.players.get(id, {}).get("name", "?")), str(data["target"]))
        "heard":
            listener.heard(str(data), id)
        "reality":
            Reality.apply_snapshot(data)
        "echo_tier":
            echo_world.manifest(data)
        "cross":
            pending_calls.push_front(data)
            if Dev.args.has("autoplay"):
                print("PRIERE CROISEE recue : ", data.get("name", "?"))
        "mis_start", "mis_done":
            missions.net_event(kind, id, data)
        "kara_cards":
            karaoke.show_cards(data)
        "dlv_req_new", "dlv_req_done", "dlv_req_late", "dlv_taken", "dlv_smack", "dlv_deliver":
            delivery.handle(kind.substr(4), data, id)
        "shout":
            var snm := str(Net.players.get(id, {}).get("name", "?"))
            _say(Loc.f("shout_other", [snm]), 4.0)
            Sfx.play("thunder", -12.0, 1.4)
            var sd := _ensure_avatar(id)
            if not sd.is_empty():
                (sd["char"]).set_emotion("shock")
            viral.highlight("shout")
        "cushion":
            _place_cushion(int(data))
        "puddle":
            _make_puddle(data)
        "fart":
            _fart_at(int(data), false)
        "steal":
            if int(data) == MY_POD and ringing:
                ringing = false
                Sfx.stop("ring")
                next_ring = t + 8.0
                _say(Loc.f("call_stolen", [str(Net.players.get(id, {}).get("name", "?"))]), 4.0)
                Sfx.play("trombone", -6.0)
        "sabotage":
            if Net.is_host():
                _do_sabotage(str(data))
        "vote":
            if Net.is_host():
                _register_vote(id, int(data))
        "vote_result":
            if overlay != null:
                overlay.show_vote_result(data)


func net_voice(id: int, frame: PackedByteArray, level: float) -> void:
    if voice == null:
        return
    voice.receive(id, frame, level, _ensure_avatar(id))


func _avatar_emote(d: Dictionary, em: String) -> void:
    var c = d["char"]
    if not bool(d["seated"]):
        c.emote(em)
    else:
        c.set_emotion("laugh" if em == "laugh" else "happy")
    Sfx.play_at(str(EMOTE_SFX.get(em, "boing")), (d["hold"] as Node3D).global_position + Vector3(0, 1.4, 0), -4.0)


# ------------------------------------------------------------- outils dev (captures)

func _autoplay(dt: float) -> void:
    # test automatique : joue une semaine complete en accelere
    auto_t += dt
    if auto_t < 0.5:
        return
    auto_t = 0.0
    if overlay.is_open():
        match str(overlay.mode):
            "intro":
                if Net.is_host() and (not Net.active or Net.all_loaded()):
                    _on_start_shift()
            "end":
                if auto_day_logged != Game.day:
                    auto_day_logged = Game.day
                    for id in Game.SHOP.keys():
                        request_buy(id)
                    print("AUTOPLAY[", Net.my_id(), "] fin du jour ", Game.day, " equipe=", solved, "/", quota, " argent ", Game.earned, " avert ", Game.strikes, " avatars=", avatars.size(), " portefeuille=", Game.wallet, " voix env/recu=", (str(voice.sent_frames) + "/" + str(voice.recv_frames)) if voice != null else "-")
                if Net.is_host():
                    _on_next_day()
            "review":
                if Net.active and Net.satan_mode and not auto_voted:
                    auto_voted = true
                    auto_wait = 0.0
                    var ids := Net.players.keys()
                    overlay._vote(int(ids[randi() % ids.size()]))
                    return
                auto_wait += 0.5
                if Net.active and Net.satan_mode and overlay.vote_lbl != null and overlay.vote_lbl.text == Loc.t("vote_sent") and auto_wait < 20.0:
                    return
                print("AUTOPLAY[", Net.my_id(), "] SEMAINE FINIE  renvoye=", Game.fired, " gagne=", Game.earned, " conversions=", Game.stats.get("conversions"), " appels=", Game.stats.get("calls"), " convertis=", Game.converted.size(), " pets=", Game.stats.get("farts", 0), " vols=", Game.stats.get("steals", 0), " vote=", overlay.vote_lbl.text if overlay.vote_lbl != null else "-", " satan=", Net.i_am_satan())
                autoplay = false
                Engine.time_scale = 1.0
                get_tree().quit()
        return
    if mass_left > 0.0:
        if seated:
            _stand()
        player.global_position = Vector3(randf_range(-1, 1), 1.0, 3.6)
        if mass_disco and not fun.danced:
            _do_emote("chicken")
        return
    if tutorial != null and not seated:
        _sit()
        return
    if not ringing and not in_call and not seated and randf() < 0.02:
        chairride.toggle()
    if chairride.riding and randf() < 0.3:
        chairride.vel = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * 11.0
    if randf() < 0.08 and not delivery.reqs.is_empty():
        var rid0 = delivery.reqs.keys()[0]
        if delivery.drops.has(rid0) and is_instance_valid(delivery.drops[rid0]):
            var r0: Dictionary = delivery.reqs[rid0]
            var tg0: Array = fun._find(str(r0["k"]), int(r0["id"]))
            if not tg0.is_empty():
                var rb0: RigidBody3D = delivery.drops[rid0]
                delivery.picked(rb0)
                rb0.global_position = (tg0[3] as Vector3) + Vector3(randf_range(-6, 6), 1.0, randf_range(-6, 6))
                var dir0: Vector3 = ((tg0[3] as Vector3) - rb0.global_position).normalized()
                rb0.linear_velocity = fun.aim_velocity(rb0.global_position, dir0, 14.0)
                fun.thrown(rb0)
    if randf() < 0.02:
        var tgs: Array = fun._targets()
        if not tgs.is_empty():
            fun.do_slap(tgs[randi() % tgs.size()])
    if randf() < 0.02:
        var ck: RigidBody3D = fun.make_chicken(player.global_position + Vector3(0, 1.2, 0))
        fun.squeeze(ck.global_position)
        var tg2: Array = fun._targets()
        if not tg2.is_empty():
            ck.global_position = (tg2[0][3] as Vector3) + Vector3(0, 0.3, 0)
            fun.thrown(ck)
    if randf() < 0.02 and not seated:
        _do_emote(EMOTES[randi() % EMOTES.size()])
    if Net.active and randf() < 0.01:
        sync.bcast(&"action", ["chat", "gg " + str(randi() % 100)])
    if randf() < 0.01 and held == null:
        var cpp := player.global_position + Vector3(0, 0.6, 0)
        var cup := _prop(cpp, Vector3(0.12, 0.15, 0.12), Color(0.9, 0.9, 0.9), 0.4, "x", true)
        cup.set_meta("cup", true)
        _spill(cup)
    if randf() < 0.01:
        var cp := randi() % PODS
        _place_cushion(cp)
        if Net.active:
            sync.bcast(&"action", ["cushion", cp])
    if Net.i_am_satan() and randf() < 0.01:
        _sabotage(["blackout", "salt", "leak"][randi() % 3])
    if Net.active and not ringing and not in_call and randf() < 0.05:
        for pod in remote_ring:
            if bool(remote_ring[pod]):
                _steal_call(int(pod))
                break
    if ringing:
        _answer()
        if not seated:
            _sit()
    elif in_call and not busy and not karaoke.active and t - auto_line_t > 2.5:
        auto_line_t = t       # un humain ecrit une ligne toutes les quelques secondes
        if randf() < 0.08 and active_powers.size() > 0:
            _use_power(randi() % active_powers.size())
        elif randf() < 0.02:
            _press_red()
        elif missions.active() and randf() < 0.6:
            var kws: PackedStringArray = str(missions.cur["k"]).split(",")
            var wtxt := str(missions.cur["w"]) if randf() < 0.12 else kws[randi() % kws.size()]
            _send_line("ah oui %s, vraiment %s" % [wtxt, kws[0]])
        else:
            _send_line("test %d" % randi())
    if task_on and randf() < 0.2:
        cof_sugar = task_sugar
        cof_milk = task_milk
        cof_big = task_big
        _make_coffee()
        _deliver()

    if not in_call and not ringing and randf() < 0.1:
        _start_minigame()
    if randf() < 0.03:
        _radio_next()
    if randf() < 0.03:
        _talk_to(randi_range(1, PODS - 1))
    if randf() < 0.03 and minigame.running:
        var mg_targets: Array = minigame.targets
        if not mg_targets.is_empty():
            minigame._hit(mg_targets[0][0], false)
    if randf() < 0.02:
        _recompile_someone()
    if randf() < 0.02:
        var pp := player.global_position + Vector3(0, 0.6, 0)
        var ball := _prop(pp, Vector3(0.14, 0.14, 0.14), Color(0.9, 0.9, 0.85), 0.12, Loc.t("prop_ball"))
        ball.global_position = bin_area.global_position + Vector3(0, 0.6, 0)




func dev_prepare(a: Dictionary) -> void:
    if a.has("echotest"):
        _echo_test()
    if a.has("echoshow"):
        _on_start_shift()
        var ep: Vector3 = earth.global_position if earth != null else Vector3.ZERO
        player.global_position = Vector3(ep.x + 5.0, 1.0, ep.z - 1.0)
        player.look_at(Vector3(ep.x, player.global_position.y, ep.z), Vector3.UP)
        pitch = 0.3
        cam.rotation.x = pitch
    if a.has("firstshow"):
        _on_start_shift()
        get_tree().create_timer(4.0).timeout.connect(echo_world.show_first.bind("Imagine si les pigeons étaient les caméras de Dieu", "SAMUEL"))
    if a.has("archives"):
        viral.open_archives()
    if a.has("mood"):
        Game.mood = str(a["mood"])
    if a.has("ride"):
        _on_start_shift()
        var dr: Dictionary = npcs[1]
        var hpr: Vector3 = (dr["hold"] as Node3D).global_position
        var awr := Vector3(hpr.x, 0, hpr.z).normalized()
        player.global_position = hpr - awr * 4.0 + Vector3(0, 0.9, 0)
        player.look_at(Vector3(hpr.x, player.global_position.y, hpr.z), Vector3.UP)
        pitch = -0.35
        cam.rotation.x = pitch
        chairride.toggle()
        chairride.vel = -player.global_transform.basis.z * 9.0
    if a.has("internshow"):
        _on_start_shift()
        player.global_position = Vector3(0, 1.0, 11.0)
        player.rotation.y = 0.0
        pitch = -0.05
        cam.rotation.x = pitch
        intern.hold.position = Vector3(0.3, 0, 8.6)
        intern.hold.rotation.y = 0.0
        intern.wait = 99.0
        intern._do("simulation", {"pos": intern.hold.global_position})
    if a.has("massnow"):
        _on_start_shift()
        mass_left = 20.0
        mass_disco = true
        player.global_position = Vector3(0, 1.0, 9.5)
        player.rotation.y = 0.0
        pitch = 0.25
        cam.rotation.x = pitch
    if a.has("smackdemo"):
        _on_start_shift()
        var d0: Dictionary = npcs[0]
        var hp0: Vector3 = (d0["char"].head as Node3D).global_position
        var away0 := Vector3(hp0.x, 0, hp0.z).normalized()
        player.global_position = hp0 - away0 * 3.2 + Vector3(0.6, -0.4, 0)
        player.look_at(Vector3(hp0.x, player.global_position.y, hp0.z), Vector3.UP)
        pitch = 0.05
        cam.rotation.x = pitch
        delivery.handle("req_new", {"rid": 99, "k": "npc", "id": int(d0["pod"]), "item": "pie", "pos": Vector3(0, 6, 4.6)}, 1)
        await get_tree().create_timer(0.3).timeout
        var pie: RigidBody3D = delivery.make_item("pie", cam.global_position - cam.global_transform.basis.z * 0.8)
        pie.set_meta("rid", 99)
        pie.linear_velocity = fun.aim_velocity(pie.global_position, (hp0 - pie.global_position).normalized(), 14.0)
        fun.thrown(pie)
        if a.has("me"):
            delivery._me_hit("pie", delivery.ITEMS["pie"], 1)
    if a.has("funny"):
        # demo : on se place devant un collegue, gifle, poulet, confettis
        _on_start_shift()
        var d: Dictionary = npcs[0]
        var hp: Vector3 = (d["hold"] as Node3D).global_position
        var away := (hp - Vector3.ZERO).normalized()
        player.global_position = hp - away * 1.7 + Vector3(0, 0.2, 0)
        player.look_at(Vector3(hp.x, player.global_position.y, hp.z), Vector3.UP)
        pitch = -0.15
        cam.rotation.x = pitch
        await get_tree().create_timer(0.5).timeout
        fun.try_slap()
        held = fun.make_chicken(player.global_position + Vector3(0.3, 0.6, 0) - player.global_transform.basis.z * 0.8)
        fun.squeeze(held.global_position)
        fun.celebrate(int(npcs[1]["pod"]) if npcs.size() > 1 else 1, false)
        await get_tree().create_timer(0.6).timeout
        fun.pop(hp + Vector3(0.6, 1.0, 0), Loc.pick("pop_fart"), Color(0.55, 0.85, 0.3), 150)
    if a.has("start") or a.has("view") or a.has("call"):
        _on_start_shift()
    match str(a.get("view", "")):
        "center":
            player.global_position = Vector3(0, 1.0, 9.0)
            player.rotation.y = 0.0
            pitch = 0.12
        "mydesk":
            var mp: Vector3 = pod_pos[MY_POD]
            var side := Vector3(-mp.z, 0, mp.x).normalized()
            player.global_position = mp * 1.22 + side * 2.6 + Vector3(0, 1.0, 0)
            player.look_at(mp + Vector3(0, 0.9, 0), Vector3.UP)
            pitch = -0.2
        "high":
            player.global_position = Vector3(0, 1.0, 14.5)
            player.rotation.y = 0.0
            pitch = 0.25
        "back":
            player.global_position = pod_pos[MY_POD] * 1.35 + Vector3(0, 1.0, 0)
            player.rotation.y = float(pod_yaw[MY_POD])
            pitch = 0.05
        "pod0", "pod4":
            var pi_v := 4 if str(a.get("view", "")) == "pod4" else 0
            var p0: Vector3 = pod_pos[pi_v]
            var s0: Vector3 = seat_pos[pi_v]
            var dv := (s0 - p0).normalized()
            player.global_position = p0 - dv * 1.9 + Vector3(0, 1.0, 0) + Vector3(dv.z, 0, -dv.x) * 0.9
            player.look_at(s0 + Vector3(0, 1.0, 0), Vector3.UP)
            pitch = -0.08
        "desk":
            var pp: Vector3 = pod_pos[1]
            var seat: Vector3 = seat_pos[1]
            var dirv := (seat - pp).normalized()
            player.global_position = pp - dirv * 1.6 + Vector3(0, 1.0, 0) + Vector3(dirv.z, 0, -dirv.x) * 0.6
            player.look_at(seat + Vector3(0, 1.0, 0), Vector3.UP)
            pitch = -0.1
        "coffee":
            var a2 := TAU / float(PODS) * 0.5
            player.global_position = Vector3(sin(a2) * (ROOM_R - 7.0), 1.0, cos(a2) * (ROOM_R - 7.0))
            player.look_at(Vector3(sin(a2) * ROOM_R, 1.0, cos(a2) * ROOM_R), Vector3.UP)
            pitch = 0.0
    cam.rotation.x = pitch
    if a.has("flash"):
        flash_on = true
    if a.has("short"):
        Game.DAYS = 2
        Game.SHIFT_SECONDS = 60.0
        shift_left = minf(shift_left, 60.0)
    if a.has("autoplay"):
        autoplay = true
        Engine.time_scale = float(a.get("speed", "12"))
        return
    if a.has("fakemate"):
        # simule un 2e joueur (CORINNE au poste 5) pour verifier le rendu sans reseau
        Net.players = {1: {"name": "SAMUEL", "pod": 0, "seed": 11, "satan": false},
            2: {"name": "CORINNE", "pod": 4, "seed": 4242, "satan": false}}
        WHO[4] = "CORINNE"
        var sp: Vector3 = seat_pos[4]
        net_pose(2, {"pos": sp + Vector3(0, 0.92, 0), "yaw": float(pod_yaw[4]), "pitch": 0.0, "seated": true, "ring": false, "talk": 0.3})
        net_call_event(2, "start", Believers.make(Loc.lang, Game.rng))
        net_call_event(2, "line", {"text": "Seigneur, j'ai léché une batterie neuve devant des enfants.", "conv": 30})
        var stand_d := _ensure_avatar(2)
        var p0: Vector3 = pod_pos[0]
        net_pose(3, {})
        Net.players[3] = {"name": "MAXIME", "pod": 2, "seed": 777, "satan": false}
        var d3 := _ensure_avatar(3)
        var p4: Vector3 = pod_pos[4]
        (d3["hold"] as Node3D).position = p4 * 0.7 + Vector3(p4.z, 0, -p4.x).normalized() * 1.2
        (d3["hold"] as Node3D).look_at(p4 * 0.3, Vector3.UP)
        d3["char"].emote("dance")
        _place_cushion(5)
        stand_d["char"].say(10.0)
    if a.has("walk"):
        _npc_go(npcs[2])
        _npc_go(npcs[5])
    if a.has("mg"):
        _sit()
        _start_minigame()
    if a.has("conf"):
        dev_kind = "conference"
    if a.has("gallery"):
        for k in ["farts", "slips", "viewer", "mass", "helium", "hoops"]:
            await get_tree().create_timer(0.6).timeout
            player.rotation.y += 0.9
            viral.hl_cd = 0.0
            viral.highlight(k, "Patate_Volante" if k == "viewer" else "")
        await get_tree().create_timer(1.0).timeout
        frozen = true
        overlay.show_review(false)
        viral.open_gallery()
        if a.has("gsave"):
            var lbl := Label.new()
            add_child(lbl)
            await viral._save_gallery(lbl)
            print("GSAVE ", lbl.text)
    if a.has("viewer"):
        Stream.channel = "test"
        Stream.handle("Patate_Volante", "!prier j'ai mangé le lunch de mon coloc et j'ai accusé le chien", Color(0.4, 1.0, 0.5))
    if a.has("call"):
        ringing = true
        _answer()
        _sit()
        if a.has("stand"):
            _stand()
        if a.has("fx"):
            await get_tree().create_timer(0.8).timeout
            var ids := ["sky", "coincidence", "witness", "smite", "frogs", "cat", "dream", "jingle", "god_yes", "god_no"]
            var fx := str(a["fx"])
            if fx in ids or fx.begins_with("gag_"):
                callview.power_fx(fx)
        if a.has("kara"):
            karaoke.start()
            karaoke.left = float(a["kara"])
        if a.has("conv"):
            conviction = int(a["conv"])
            callview.set_conviction(conviction)
    match str(a.get("overlay", "")):
        "intro":
            frozen = true
            overlay.show_intro()
        "end":
            frozen = true
            Game.wallet = 1400
            overlay.show_end("strike", 1, 3)
        "review":
            frozen = true
            Game.earned = 7340
            for k in 5:
                Game.converted.append(Believers.make(Loc.lang, Game.rng))
            Game.best_quote = {"line": "Ok mais si Dieu dit que le ketchup c'est correct, je vais en mettre dans le café aussi.", "who": "Kyle Bennett", "score": 9}
            overlay.show_review(true)
