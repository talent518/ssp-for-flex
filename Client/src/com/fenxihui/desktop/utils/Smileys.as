package com.fenxihui.desktop.utils
{
	import mx.collections.ArrayCollection;

	public class Smileys
	{
		[Embed(source="smileys/001-微笑.swf")]
		[Bindable]
		private static var _smileys_001:Class;
		
		[Embed(source="smileys/002-撇嘴.swf")]
		[Bindable]
		private static var _smileys_002:Class;
		
		[Embed(source="smileys/003-色.swf")]
		[Bindable]
		private static var _smileys_003:Class;
		
		[Embed(source="smileys/004-发呆.swf")]
		[Bindable]
		private static var _smileys_004:Class;
		
		[Embed(source="smileys/005-得意.swf")]
		[Bindable]
		private static var _smileys_005:Class;
		
		[Embed(source="smileys/006-流泪.swf")]
		[Bindable]
		private static var _smileys_006:Class;
		
		[Embed(source="smileys/007-害羞.swf")]
		[Bindable]
		private static var _smileys_007:Class;
		
		[Embed(source="smileys/008-闭嘴.swf")]
		[Bindable]
		private static var _smileys_008:Class;
		
		[Embed(source="smileys/009-睡.swf")]
		[Bindable]
		private static var _smileys_009:Class;
		
		[Embed(source="smileys/010-大哭.swf")]
		[Bindable]
		private static var _smileys_010:Class;
		
		[Embed(source="smileys/011-尴尬.swf")]
		[Bindable]
		private static var _smileys_011:Class;
		
		[Embed(source="smileys/012-发怒.swf")]
		[Bindable]
		private static var _smileys_012:Class;
		
		[Embed(source="smileys/013-调皮.swf")]
		[Bindable]
		private static var _smileys_013:Class;
		
		[Embed(source="smileys/014-呲牙.swf")]
		[Bindable]
		private static var _smileys_014:Class;
		
		[Embed(source="smileys/015-惊讶.swf")]
		[Bindable]
		private static var _smileys_015:Class;
		
		[Embed(source="smileys/016-难过.swf")]
		[Bindable]
		private static var _smileys_016:Class;
		
		[Embed(source="smileys/017-酷.swf")]
		[Bindable]
		private static var _smileys_017:Class;
		
		[Embed(source="smileys/018-冷汗.swf")]
		[Bindable]
		private static var _smileys_018:Class;
		
		[Embed(source="smileys/019-抓狂.swf")]
		[Bindable]
		private static var _smileys_019:Class;
		
		[Embed(source="smileys/020-吐.swf")]
		[Bindable]
		private static var _smileys_020:Class;
		
		[Embed(source="smileys/021-偷笑.swf")]
		[Bindable]
		private static var _smileys_021:Class;
		
		[Embed(source="smileys/022-可爱.swf")]
		[Bindable]
		private static var _smileys_022:Class;
		
		[Embed(source="smileys/023-白眼.swf")]
		[Bindable]
		private static var _smileys_023:Class;
		
		[Embed(source="smileys/024-傲慢.swf")]
		[Bindable]
		private static var _smileys_024:Class;
		
		[Embed(source="smileys/025-饥饿.swf")]
		[Bindable]
		private static var _smileys_025:Class;
		
		[Embed(source="smileys/026-困.swf")]
		[Bindable]
		private static var _smileys_026:Class;
		
		[Embed(source="smileys/027-惊慌.swf")]
		[Bindable]
		private static var _smileys_027:Class;
		
		[Embed(source="smileys/028-流汗.swf")]
		[Bindable]
		private static var _smileys_028:Class;
		
		[Embed(source="smileys/029-憨笑.swf")]
		[Bindable]
		private static var _smileys_029:Class;
		
		[Embed(source="smileys/030-大兵.swf")]
		[Bindable]
		private static var _smileys_030:Class;
		
		[Embed(source="smileys/031-奋斗.swf")]
		[Bindable]
		private static var _smileys_031:Class;
		
		[Embed(source="smileys/032-咒骂.swf")]
		[Bindable]
		private static var _smileys_032:Class;
		
		[Embed(source="smileys/033-疑问.swf")]
		[Bindable]
		private static var _smileys_033:Class;
		
		[Embed(source="smileys/034-嘘.swf")]
		[Bindable]
		private static var _smileys_034:Class;
		
		[Embed(source="smileys/035-晕.swf")]
		[Bindable]
		private static var _smileys_035:Class;
		
		[Embed(source="smileys/036-折磨.swf")]
		[Bindable]
		private static var _smileys_036:Class;
		
		[Embed(source="smileys/037-哀.swf")]
		[Bindable]
		private static var _smileys_037:Class;
		
		[Embed(source="smileys/038-骷髅.swf")]
		[Bindable]
		private static var _smileys_038:Class;
		
		[Embed(source="smileys/039-敲打.swf")]
		[Bindable]
		private static var _smileys_039:Class;
		
		[Embed(source="smileys/040-再见.swf")]
		[Bindable]
		private static var _smileys_040:Class;
		
		[Embed(source="smileys/041-擦汗.swf")]
		[Bindable]
		private static var _smileys_041:Class;
		
		[Embed(source="smileys/042-抠鼻.swf")]
		[Bindable]
		private static var _smileys_042:Class;
		
		[Embed(source="smileys/043-鼓掌.swf")]
		[Bindable]
		private static var _smileys_043:Class;
		
		[Embed(source="smileys/044-糗大了.swf")]
		[Bindable]
		private static var _smileys_044:Class;
		
		[Embed(source="smileys/045-坏笑.swf")]
		[Bindable]
		private static var _smileys_045:Class;
		
		[Embed(source="smileys/046-左哼哼.swf")]
		[Bindable]
		private static var _smileys_046:Class;
		
		[Embed(source="smileys/047-右哼哼.swf")]
		[Bindable]
		private static var _smileys_047:Class;
		
		[Embed(source="smileys/048-哈欠.swf")]
		[Bindable]
		private static var _smileys_048:Class;
		
		[Embed(source="smileys/049-鄙视.swf")]
		[Bindable]
		private static var _smileys_049:Class;
		
		[Embed(source="smileys/050-委屈.swf")]
		[Bindable]
		private static var _smileys_050:Class;
		
		[Embed(source="smileys/051-快哭了.swf")]
		[Bindable]
		private static var _smileys_051:Class;
		
		[Embed(source="smileys/052-阴险.swf")]
		[Bindable]
		private static var _smileys_052:Class;
		
		[Embed(source="smileys/053-亲亲.swf")]
		[Bindable]
		private static var _smileys_053:Class;
		
		[Embed(source="smileys/054-吓.swf")]
		[Bindable]
		private static var _smileys_054:Class;
		
		[Embed(source="smileys/055-可怜.swf")]
		[Bindable]
		private static var _smileys_055:Class;
		
		[Embed(source="smileys/056-菜刀.swf")]
		[Bindable]
		private static var _smileys_056:Class;
		
		[Embed(source="smileys/057-西瓜.swf")]
		[Bindable]
		private static var _smileys_057:Class;
		
		[Embed(source="smileys/058-啤酒.swf")]
		[Bindable]
		private static var _smileys_058:Class;
		
		[Embed(source="smileys/059-篮球.swf")]
		[Bindable]
		private static var _smileys_059:Class;
		
		[Embed(source="smileys/060-乒乓.swf")]
		[Bindable]
		private static var _smileys_060:Class;
		
		[Embed(source="smileys/061-咖啡.swf")]
		[Bindable]
		private static var _smileys_061:Class;
		
		[Embed(source="smileys/062-饭.swf")]
		[Bindable]
		private static var _smileys_062:Class;
		
		[Embed(source="smileys/063-猪头.swf")]
		[Bindable]
		private static var _smileys_063:Class;
		
		[Embed(source="smileys/064-玫瑰.swf")]
		[Bindable]
		private static var _smileys_064:Class;
		
		[Embed(source="smileys/065-凋谢.swf")]
		[Bindable]
		private static var _smileys_065:Class;
		
		[Embed(source="smileys/066-示爱.swf")]
		[Bindable]
		private static var _smileys_066:Class;
		
		[Embed(source="smileys/067-爱心.swf")]
		[Bindable]
		private static var _smileys_067:Class;
		
		[Embed(source="smileys/068-心碎.swf")]
		[Bindable]
		private static var _smileys_068:Class;
		
		[Embed(source="smileys/069-蛋糕.swf")]
		[Bindable]
		private static var _smileys_069:Class;
		
		[Embed(source="smileys/070-闪电.swf")]
		[Bindable]
		private static var _smileys_070:Class;
		
		[Embed(source="smileys/071-炸弹.swf")]
		[Bindable]
		private static var _smileys_071:Class;
		
		[Embed(source="smileys/072-刀.swf")]
		[Bindable]
		private static var _smileys_072:Class;
		
		[Embed(source="smileys/073-足球.swf")]
		[Bindable]
		private static var _smileys_073:Class;
		
		[Embed(source="smileys/074-瓢虫.swf")]
		[Bindable]
		private static var _smileys_074:Class;
		
		[Embed(source="smileys/075-便便.swf")]
		[Bindable]
		private static var _smileys_075:Class;
		
		[Embed(source="smileys/076-月亮.swf")]
		[Bindable]
		private static var _smileys_076:Class;
		
		[Embed(source="smileys/077-太阳.swf")]
		[Bindable]
		private static var _smileys_077:Class;
		
		[Embed(source="smileys/078-礼物.swf")]
		[Bindable]
		private static var _smileys_078:Class;
		
		[Embed(source="smileys/079-拥抱.swf")]
		[Bindable]
		private static var _smileys_079:Class;
		
		[Embed(source="smileys/080-强.swf")]
		[Bindable]
		private static var _smileys_080:Class;
		
		[Embed(source="smileys/081-弱.swf")]
		[Bindable]
		private static var _smileys_081:Class;
		
		[Embed(source="smileys/082-握手.swf")]
		[Bindable]
		private static var _smileys_082:Class;
		
		[Embed(source="smileys/083-胜利.swf")]
		[Bindable]
		private static var _smileys_083:Class;
		
		[Embed(source="smileys/084-抱拳.swf")]
		[Bindable]
		private static var _smileys_084:Class;
		
		[Embed(source="smileys/085-勾引.swf")]
		[Bindable]
		private static var _smileys_085:Class;
		
		[Embed(source="smileys/086-拳头.swf")]
		[Bindable]
		private static var _smileys_086:Class;
		
		[Embed(source="smileys/087-差劲.swf")]
		[Bindable]
		private static var _smileys_087:Class;
		
		[Embed(source="smileys/088-爱你.swf")]
		[Bindable]
		private static var _smileys_088:Class;
		
		[Embed(source="smileys/089-NO.swf")]
		[Bindable]
		private static var _smileys_089:Class;
		
		[Embed(source="smileys/090-OK.swf")]
		[Bindable]
		private static var _smileys_090:Class;
		
		[Embed(source="smileys/091-爱情.swf")]
		[Bindable]
		private static var _smileys_091:Class;
		
		[Embed(source="smileys/092-飞吻.swf")]
		[Bindable]
		private static var _smileys_092:Class;
		
		[Embed(source="smileys/093-跳跳.swf")]
		[Bindable]
		private static var _smileys_093:Class;
		
		[Embed(source="smileys/094-发抖.swf")]
		[Bindable]
		private static var _smileys_094:Class;
		
		[Embed(source="smileys/095-怄火.swf")]
		[Bindable]
		private static var _smileys_095:Class;
		
		[Embed(source="smileys/096-转圈.swf")]
		[Bindable]
		private static var _smileys_096:Class;
		
		[Embed(source="smileys/097-磕头.swf")]
		[Bindable]
		private static var _smileys_097:Class;
		
		[Embed(source="smileys/098-回头.swf")]
		[Bindable]
		private static var _smileys_098:Class;
		
		[Embed(source="smileys/099-跳绳.swf")]
		[Bindable]
		private static var _smileys_099:Class;
		
		[Embed(source="smileys/100-挥手.swf")]
		[Bindable]
		private static var _smileys_100:Class;
		
		[Embed(source="smileys/101-激动.swf")]
		[Bindable]
		private static var _smileys_101:Class;
		
		[Embed(source="smileys/102-街舞.swf")]
		[Bindable]
		private static var _smileys_102:Class;
		
		[Embed(source="smileys/103-献吻.swf")]
		[Bindable]
		private static var _smileys_103:Class;
		
		[Embed(source="smileys/104-左太极.swf")]
		[Bindable]
		private static var _smileys_104:Class;
		
		[Embed(source="smileys/105-右太极.swf")]
		[Bindable]
		private static var _smileys_105:Class;
		
		public static function get smileys():Array{
			return [
				{data:"001",toolTip:"微笑",icon:_smileys_001},
				{data:"002",toolTip:"撇嘴",icon:_smileys_002},
				{data:"003",toolTip:"色",icon:_smileys_003},
				{data:"004",toolTip:"发呆",icon:_smileys_004},
				{data:"005",toolTip:"得意",icon:_smileys_005},
				{data:"006",toolTip:"流泪",icon:_smileys_006},
				{data:"007",toolTip:"害羞",icon:_smileys_007},
				{data:"008",toolTip:"闭嘴",icon:_smileys_008},
				{data:"009",toolTip:"睡",icon:_smileys_009},
				{data:"010",toolTip:"大哭",icon:_smileys_010},
				{data:"011",toolTip:"尴尬",icon:_smileys_011},
				{data:"012",toolTip:"发怒",icon:_smileys_012},
				{data:"013",toolTip:"调皮",icon:_smileys_013},
				{data:"014",toolTip:"呲牙",icon:_smileys_014},
				{data:"015",toolTip:"惊讶",icon:_smileys_015},
				{data:"016",toolTip:"难过",icon:_smileys_016},
				{data:"017",toolTip:"酷",icon:_smileys_017},
				{data:"018",toolTip:"冷汗",icon:_smileys_018},
				{data:"019",toolTip:"抓狂",icon:_smileys_019},
				{data:"020",toolTip:"吐",icon:_smileys_020},
				{data:"021",toolTip:"偷笑",icon:_smileys_021},
				{data:"022",toolTip:"可爱",icon:_smileys_022},
				{data:"023",toolTip:"白眼",icon:_smileys_023},
				{data:"024",toolTip:"傲慢",icon:_smileys_024},
				{data:"025",toolTip:"饥饿",icon:_smileys_025},
				{data:"026",toolTip:"困",icon:_smileys_026},
				{data:"027",toolTip:"惊慌",icon:_smileys_027},
				{data:"028",toolTip:"流汗",icon:_smileys_028},
				{data:"029",toolTip:"憨笑",icon:_smileys_029},
				{data:"030",toolTip:"大兵",icon:_smileys_030},
				{data:"031",toolTip:"奋斗",icon:_smileys_031},
				{data:"032",toolTip:"咒骂",icon:_smileys_032},
				{data:"033",toolTip:"疑问",icon:_smileys_033},
				{data:"034",toolTip:"嘘",icon:_smileys_034},
				{data:"035",toolTip:"晕",icon:_smileys_035},
				{data:"036",toolTip:"折磨",icon:_smileys_036},
				{data:"037",toolTip:"哀",icon:_smileys_037},
				{data:"038",toolTip:"骷髅",icon:_smileys_038},
				{data:"039",toolTip:"敲打",icon:_smileys_039},
				{data:"040",toolTip:"再见",icon:_smileys_040},
				{data:"041",toolTip:"擦汗",icon:_smileys_041},
				{data:"042",toolTip:"抠鼻",icon:_smileys_042},
				{data:"043",toolTip:"鼓掌",icon:_smileys_043},
				{data:"044",toolTip:"糗大了",icon:_smileys_044},
				{data:"045",toolTip:"坏笑",icon:_smileys_045},
				{data:"046",toolTip:"左哼哼",icon:_smileys_046},
				{data:"047",toolTip:"右哼哼",icon:_smileys_047},
				{data:"048",toolTip:"哈欠",icon:_smileys_048},
				{data:"049",toolTip:"鄙视",icon:_smileys_049},
				{data:"050",toolTip:"委屈",icon:_smileys_050},
				{data:"051",toolTip:"快哭了",icon:_smileys_051},
				{data:"052",toolTip:"阴险",icon:_smileys_052},
				{data:"053",toolTip:"亲亲",icon:_smileys_053},
				{data:"054",toolTip:"吓",icon:_smileys_054},
				{data:"055",toolTip:"可怜",icon:_smileys_055},
				{data:"056",toolTip:"菜刀",icon:_smileys_056},
				{data:"057",toolTip:"西瓜",icon:_smileys_057},
				{data:"058",toolTip:"啤酒",icon:_smileys_058},
				{data:"059",toolTip:"篮球",icon:_smileys_059},
				{data:"060",toolTip:"乒乓",icon:_smileys_060},
				{data:"061",toolTip:"咖啡",icon:_smileys_061},
				{data:"062",toolTip:"饭",icon:_smileys_062},
				{data:"063",toolTip:"猪头",icon:_smileys_063},
				{data:"064",toolTip:"玫瑰",icon:_smileys_064},
				{data:"065",toolTip:"凋谢",icon:_smileys_065},
				{data:"066",toolTip:"示爱",icon:_smileys_066},
				{data:"067",toolTip:"爱心",icon:_smileys_067},
				{data:"068",toolTip:"心碎",icon:_smileys_068},
				{data:"069",toolTip:"蛋糕",icon:_smileys_069},
				{data:"070",toolTip:"闪电",icon:_smileys_070},
				{data:"071",toolTip:"炸弹",icon:_smileys_071},
				{data:"072",toolTip:"刀",icon:_smileys_072},
				{data:"073",toolTip:"足球",icon:_smileys_073},
				{data:"074",toolTip:"瓢虫",icon:_smileys_074},
				{data:"075",toolTip:"便便",icon:_smileys_075},
				{data:"076",toolTip:"月亮",icon:_smileys_076},
				{data:"077",toolTip:"太阳",icon:_smileys_077},
				{data:"078",toolTip:"礼物",icon:_smileys_078},
				{data:"079",toolTip:"拥抱",icon:_smileys_079},
				{data:"080",toolTip:"强",icon:_smileys_080},
				{data:"081",toolTip:"弱",icon:_smileys_081},
				{data:"082",toolTip:"握手",icon:_smileys_082},
				{data:"083",toolTip:"胜利",icon:_smileys_083},
				{data:"084",toolTip:"抱拳",icon:_smileys_084},
				{data:"085",toolTip:"勾引",icon:_smileys_085},
				{data:"086",toolTip:"拳头",icon:_smileys_086},
				{data:"087",toolTip:"差劲",icon:_smileys_087},
				{data:"088",toolTip:"爱你",icon:_smileys_088},
				{data:"089",toolTip:"NO",icon:_smileys_089},
				{data:"090",toolTip:"OK",icon:_smileys_090},
				{data:"091",toolTip:"爱情",icon:_smileys_091},
				{data:"092",toolTip:"飞吻",icon:_smileys_092},
				{data:"093",toolTip:"跳跳",icon:_smileys_093},
				{data:"094",toolTip:"发抖",icon:_smileys_094},
				{data:"095",toolTip:"怄火",icon:_smileys_095},
				{data:"096",toolTip:"转圈",icon:_smileys_096},
				{data:"097",toolTip:"磕头",icon:_smileys_097},
				{data:"098",toolTip:"回头",icon:_smileys_098},
				{data:"099",toolTip:"跳绳",icon:_smileys_099},
				{data:"100",toolTip:"挥手",icon:_smileys_100},
				{data:"101",toolTip:"激动",icon:_smileys_101},
				{data:"102",toolTip:"街舞",icon:_smileys_102},
				{data:"103",toolTip:"献吻",icon:_smileys_103},
				{data:"104",toolTip:"左太极",icon:_smileys_104},
				{data:"105",toolTip:"右太极",icon:_smileys_105}
			];
		};
	}
}