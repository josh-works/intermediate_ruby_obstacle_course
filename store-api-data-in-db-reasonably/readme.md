# README

I want to model data quickly in a DB, based on the raw data coming from [https://github.com/josh-works/strava_run_polylines_osm](https://github.com/josh-works/strava_run_polylines_osm)

Really should take just a few minutes. Lets proceed...

Obstacle course steps:

sidebar: I just ran the following `rails new` command, then imagining the `seeds.rb` file.

```
rails _7.0.3_ new mobility-maps --css=tailwind -d=postgresql
```

I was riding my scooter around today, and wanted to practice storing a full entry from here:

[https://github.com/josh-works/strava_run_polylines_osm/blob/main/data/activities-all.json](https://github.com/josh-works/strava_run_polylines_osm/blob/main/data/activities-all.json)

I want to be able to say in a rails concole `Activity.all` and have this full blob of data come back, under the following conditions:

- stored in the DB with a GUID, not an ID
- store the strava DB of course
- all other attributes in this activity

## Mega interesting additions

TODO: Find tweet saying (from some well-established person):

> save yourself pain, assume you'll have users and teams, with a m:m relationship

So I want to model me, Josh, a mobility-network-user, and associate me with a team, maybe `denver scooter riders`

I should be able to join/leave the team. Mostly I wanna MVP this for practice, and practice some VCR and testing stuff.

- create a bare-bones app that fulfills the following criteria:

```ruby
# db/seeds.rb
# see if you can follow with me.

mnu = MobilityNetworkUser.new(name: "Josh Thompson", strava_athlete_id: "abc")
team = Team.new(name: "Denver Scooter Riders", admin: mnu)

activity = {
  "id": 5648639527,
  "name": "Church to clear Creek",
  "distance": 968.9,
  "moving_time": 612,
  "elapsed_time": 3366,
  "total_elevation_gain": 2.8,
  "elev_high": 1742.7,
  "elev_low": 1729.7,
  "average_speed": 1.583,
  "max_speed": 5.5,
  "average_heartrate": null,
  "max_heartrate": null,
  "start_date": "2021-07-18 16:12:33+00:00"
}

mnu.activity.create(activity)
```



And I should be able to go to the browser and visit `localhost:3000/mnu_guid/activity_guid`

And see this data rendered. It should be pretty chill? Reader, does this feel simple? What about making sure you've got tests for it? What about adding a strava client that loads all this data from Strava, so we can have 400 or 1000 entries?

Because next, I have `runs.csv`:

```
id,polyline
7111397340,egcqFp_w_SAEGCFDC??JGGUZMd@Gx@A|A@|@?jBNhICrABpBE~@AfDHfBClBAPGLc@EaC@kCGiCD_BFkAEmCB_HGcBFwACu@Ds@N[AA@JBBDACC?KJa@BIFSZCJJlC@xA?rADhFClFBrAAxA@VEpBBfDAhD@dDQjNAJUKKCuB\q@Rq@b@UTi@v@iC|E{AlCYZo@l@{A~@MJGLG`@@dJGhCEjFK`GBnCJzBBpDG|IDbAGhE@hDBdAAxDGxB@nAIl@DDBr@GpJFvAAtAD|BHlBAVGRBl@?hCEt@ApCKnACr@@h@NzBDrA?^HH@JBzAEv@ECCPCrADfIApBIdBApBHvEAf@IhAKfC?pAFhCFpELbEAt@B`CFfBBpBEhEDvAAxFFxCAnAG~AB~FEnC?`DIrBDpCIpDClDBxBGhEF`DHvC?tBOrIB`AEdFFrD?tCIzEFnB?v@HHEZAl@FhDChCDvHAfDE|B@nCCzH@fEJzECnA?vFEpCH`IAhED|FElAAjBDhIGlDD~GChCOrGFvCF~@Ib@@p@CxB?tAF|A?xAKxCK~JLhNDnABzKChHEzA@|CCzCBdGE|ATxKA~BG`BAp@LxGC|HRxG?v@EdE?bDF`FEhH?|CDrE?zCErEKdEBzEGvHF|CEtCG~A?|ABtA?~BBrADNRDa@?LJIB?JApCH|ABdCCpIHxEAxHGnF?hC@lE?GFhA@`BFtIC`X?d@Df@V|AbCfIl@nCz@`DnBbI^`CP`BH~AZbKZdIDhDAp@Ep@S|AMn@o@fCgEvOoCxJ]dCK|AAr@@~FD`CFp@X`Bn@~BZvAL`BBl@CpAGfB?OCIAFUHEN?DTTDLYbCDzAFj@ZrAh@lBfAbDNj@Jj@f@hEBp@AhBMdBk@`Ek@dFUrCw@bFYxC_@tCYfD[bBqA`Gq@pD[zBk@jDy@dHi@fDm@vB_BxEUt@oA`FoAnEkApEi@bBeArCq@tAeAlBmCtFi@~@g@`A]`Ag@rBEf@ApALnCD^ZlA^fAr@pAt@r@FVAHEHWPe@J_AFcA@o@FaEtAc@HwC\}D\sBLiA?mAC{Mq@}DMaE]cAC[D_Cz@sGhBaBj@{@VmDfA_GrAsBl@oBr@iHbDc@NkAXkALe@@kAEsC[eAWmAe@e@W_@Yu@u@w@o@YYW[_AgB{AeEi@cAq@q@YQUKWAUBUFSL_@`@MTsBnG{@bC_AzBu@jA_AhAeA`Aa@T}@b@eEvAe@LqARuAL{AFqIVoCTqD`@UJSNOT_AnBOVMFE?GCSUKUM]YgAuA}Dc@wA{AaEkDwKuAeE_A{C]u@Ia@BGIc@IWq@oAuAwDeAyBi@sACA@AGAH?@DOGQ@INCZEdBChFFfEB~DDdVLtDBA?EBD?FKp@Q`@YhFc@fB{@rCQd@k@jAYd@qA`BeHnHiBbCWf@kA`Dq@zCQpA[dD]jCc@hCi@xBQb@eChEgBbCwAzAcDxBkCnBkCxBqD`DmBzAiHnGg@ZoAdAkBrAmDvCkBrAgB|AkBvAiB`BsDpCsApA{EjDkAn@eCfAk@`@gA|@y@h@M@IAICSSY_@aB_Ds@iACOAQDg@COM?GFOb@IL}@dA}@x@eBlBaA|@gAz@KNSr@Wf@eDpCoAnAGDG?UOGK_@cAkAqCIEK@eAjAwApAiC|CgAx@GLi@j@iBvAK@UIKKc@mA[s@_@uAeDyGiA{CkAgCYa@IEQFMJs@z@gB`BkAlA}C`CiDrC[T{BrBs@j@eB|AcBlB}AvAuFvEkAhAw@p@cAjAeAr@k@p@gA|Aq@|@_B`C?Os@}Aa@u@w@iCBGH@BAAEBD@AAEEBHAGBJA?BHIAB
7110998724,wqbqFv`x_SGoAAuALoEAqBBsBK_IEoHBoDAmL@cBGWCFQvBCBQBo@Ee@DOEaA_@c@MMKU?mA\YDIWC_@I[GGQC}@BoAPq@AK_@Iy@GIICWCaARcDVa@?o@C[MKCYByCBcACy@@g@AOCEIE]KiAEqCBmAAsABg@CEAFBDeBQs@?{CIgC@GGCGAcDCCGAQB]COD@F@?BCEBAC?BG@?EBEQ_ABBEM?EBJDFHCv@?T@XDJAC?CKCBAJDEA@?GBKAACH@IACOTNI@KCGANGFYNKHIBK?QI@F?KB@@DCD?KEFBGB@@C?IBBIFBKA@HFE?GMDF@CEC?DCKG@BPGA@CPAMB@FG?FCEFBEHDGIDEAE?HD?GDCA@VIt@@ECEADPXJjAJ`@LLFPLF|@X`BE\BhAAxAI`B?LAHG@KCcABaEGoDBMDIHCbCE|@@jCLRAlABfBApCFhEAzADTBJ?JBDCEIKD@ZCAHCACC@?HC@AEJKADACG?B??H?AB@CFBKCLACBTEAAL@C?LA@FD@CBDEAAA?BGM@C?@AA@?@B@ECBBE@SAUFSAL@IEGC?AGEEFCABC@GEB??GBAHBBHAFAADAGV@NB@@LEH?VC?AE@GCLCBBIAQDIABB@?TBBC@EC?BA?DA?BBEABB@OI?BC@DAFDDCB@DAI@@AM?B@?CF??CE@F?C@EJBE@BCBCGBB@G
7110530106,myuqFxsgaSCFEDBKB@@CON@ICE??AD@CF@FCEHSBDFEEEB?LXbAl@nAfAhCIVFDXBPJd@b@pD~Dd@p@HRR~AARCPWVGH@DRBxBi@rAQ`AKfAGlA?lAFpANpATh@LtE~AnDpAfDhAdAb@bAh@^ZjBnBv@l@|@`@^J`@F|@BdDUv@OrA_@ZMt@c@nB}AnA_BhCqDl@kAd@oAx@sDR_BLeBNoJLeBJq@Nm@b@qAj@iAp@aAx@y@|@w@~BkBdCiBbByA^a@`M}J~D{C`FgEnB_BpCeCzM}KzFsEtDaDhBwA|IqHjCsBlL{J|@q@j@i@bAoAhBwC^{@t@gCf@eCDa@NmBNqA|@qGn@sCj@}Ar@wAx@qAbAeApDeDhBiBb@c@`AsAx@{AVm@h@_B^gBVmBNkBDgBCoHIcICwHYcQ?qCO_DQeBQcA]gAuAiEiAcDgAuDmAiFqA_IyBaMa@mBwC{P_BmIo@wCQqAi@eDe@yBSqAm@cFk@}DIISaBg@uCMoAe@kDYuCs@}F@MoAuHs@sDe@{Ak@{Aq@yAu@wAmOgTsDqFgAgBk@gA]w@m@mBYsAU_Bg@{Ho@oIy@eNGyCYgDcAiP]wGQgCGaBY_Ea@oJMsGIyIFyUEiNC{YBqEBQRaAAKM_@GYBaA?_JGiGAqT@uGEiOJuK@UDERIFM@OFEf@Jh@@P?HCL^FBNODQ@WEm@?i@EIKGQEmCQKGEMAU@wAEgEGoT?}TFgD?kGEgK?qGEmKDyGEqDDoB@cHCcGEmBG}GHoKAoCL_GEK?CDAC]?{CQkGAwHAkBDmBEeOFaKAK@yCCcDAgKDgFDIFETAHECIIEMAMGIOGUAYA}IFeEB{F@IPU?ISi@EmIAyN@m\CY?oMCaBB{CEqJB{B?qIByA?mD@a@LWMUCiACmCBoEA?Ae@@gEKiEHyH@mFCmDHcGAwKBi@?ACB?B@qBEkBCmHJsDBuAG_FIgDSoOCwCAyVh@if@Vmc@NaJ@MDGHELAf@BlBI~@?`BBnAF`DElAFxCAj@@|EElBDZCr@Ft@AxAI~@@x@H`@CPKDQ?eC@y@DIHGLAtEC^E\A~FRhB?FET]SwBCcADSDCJCd@CfB@fL@f@ENKLBBC@FFGGB@LLBADCC?HCFAEBAAJAOAP?@@C@D@LCB?BAY@@@ACJAGCDAE?D?F@A@@?K@D@GABB?ACA^@a@AU?@@I?DAC@BEK?L@@@I?J?OBTCF?A@A@B?D@A?CCD@BC@@QBAIG?LCK?JCBDAADA]BSTmAALGF@@DEGUEEB?@JERBDF?GIBAXNFJABGCIOAMC?Be@CXAOAl@AGBHCI
```

```ruby
extra_run_1 = {id: "strava-provided-id1", polyline: "polyline1"}
extra_run_2 = {id: "strava-provided-id2", polyline: "polyline2"}
extra_run_3 = {id: "strava-provided-id3", polyline: "polyline3"}

Activity.associate_run(extra_run_1)
Activity.associate_run(extra_run_2)
Activity.associate_run(extra_run_3)

mnu.activities.first.run
=> extra_run_1

Team.members.first
=> mnu
```


Learnings:

- [ ] quickly model DB tables with GUIDs & any params gathering data from any source (CSV, JSON API, etc)
- [ ] relate that data with itself, keeping both your own db schema (GUIDS) and internal references (`activity.id` => `CSV [id]`), so i'll need to be smart about foreign keys
- [ ] testing at some point, using Mocks/Stubs & VCR & Fixtures (diff/compare-contrast)
