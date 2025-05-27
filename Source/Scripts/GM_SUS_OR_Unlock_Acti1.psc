Scriptname GM_SUS_OR_Unlock_Acti1 extends ObjectReference  
{This script moves a marker to its own location, then the GM_SUS_Unlock_Qust1 uses that marker to find a locked object.}

; =============================================================
; VARIABLES
; =============================================================

; Properties -----------------------------------------------------

Actor                   Property        _PLAYERREF          Auto
{Set this to the player reference.}

EffectShader            Property        _EFFECT1            Auto
{This effect applies to the locked object when it is unlocked.}

ObjectReference         Property        _OBJREF1            Auto
{The marker object reference placed in the game world, and used by the Marker alias.}

Perk[]                  Property        _PERK_ARRAY         Auto
{Check if the player has an alteration cost reduction perk.}

Quest                   Property        _QUEST1             Auto
{The GM_SUS_Unlock_Qust1 quest is used to fill the aliases.}

ReferenceAlias          Property        _REFALIAS1          Auto
{The LockedTarget alias that the quest uses to select the nearest locked object.}

Sound                   Property        _SOUND1             Auto
{Sound effect that plays when the object is unlocked.}
Sound                   Property        _SOUND2             Auto
{Sound effect that plays if the player does not have enough magicka.}

; Private -----------------------------------------------------

ObjectReference         _locked_or

; =============================================================
; EVENTS
; =============================================================

Event OnInit()

    GotoState("Created")

EndEvent

; =============================================================
; FUNCTIONS
; =============================================================

Function UnlockTarget(float a_mag = 0.0, float a_bool = 0.0, float a_skill = 0.0)
    
    float _mod_f = _PLAYERREF.GetActorValue("AlterationMod")

    If (_mod_f < 100)
        
        Debug.Trace("alteration mod = " + _mod_f)
        a_mag -= (_mod_f * 0.01) * a_mag

    ElseIf (_mod_f > 99)
        
        a_mag = 0

    EndIf

    If (a_bool)
        
        Debug.Trace("player has reduction perk!" )
        a_mag *= 0.5

    EndIf

    If (a_mag > _PLAYERREF.GetActorValue("Magicka"))

        _SOUND2.Play(_PLAYERREF)
        Debug.Notification("You need at least " + a_mag as int + " magicka to alter this lock.")
    
    Else
        
        Debug.Trace("magicka cost = " + a_mag)
        _PLAYERREF.DamageActorValue("Magicka", a_mag)
        _locked_or.Lock(false)
        _SOUND1.Play(_locked_or)
        _EFFECT1.Play(_locked_or, 1.0)
        Game.AdvanceSkill("Alteration", a_skill)
            
    EndIf
    
EndFunction

Function CheckLockLvl(int a_value)
    
    If (a_value < 2)            ;Novice
        
        UnlockTarget(80 , _PLAYERREF.HasPerk(_PERK_ARRAY[0]) as float , 50)
    
    ElseIf (a_value < 26)       ;Apprentice
        
        UnlockTarget(160 , _PLAYERREF.HasPerk(_PERK_ARRAY[1]) as float , 100)

    ElseIf (a_value < 51)       ;Adept
        
        UnlockTarget(240 , _PLAYERREF.HasPerk(_PERK_ARRAY[2]) as float , 150)

    ElseIf (a_value < 76)       ;Expert
        
        UnlockTarget(320 , _PLAYERREF.HasPerk(_PERK_ARRAY[3]) as float , 200)

    ElseIf (a_value < 255)      ;Master
        
        UnlockTarget(400 , _PLAYERREF.HasPerk(_PERK_ARRAY[4]) as float , 250)

    Else                        ;Key
        
        Debug.Notification("This lock cannot be altered. It requires a key to open.")

    EndIf

EndFunction

Function CleanUp()

    Debug.Trace("finished!")
    _QUEST1.Stop()
    Self.Delete()

EndFunction

; =============================================================
; STATES
; =============================================================

State Created

    Event OnBeginState()
    
        If (_QUEST1.IsRunning())
        
            Debug.Trace("quest is running!")
            Self.Delete()
            return

        EndIf

        _OBJREF1.MoveTo(Self)
        _QUEST1.Start()
        _locked_or = _REFALIAS1.GetReference()

        If (!_locked_or)

            CleanUp()
            return

        EndIf

        Debug.Trace("LockedTarget = " + _locked_or)
        CheckLockLvl(_locked_or.GetLockLevel())

        GotoState("")

    EndEvent



    Event OnEndState()

        CleanUp()

    EndEvent

EndState