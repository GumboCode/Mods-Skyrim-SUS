Scriptname GM_SUS_OR_Unlock_Acti1Ref extends ObjectReference  
{This is used on the GM_SUS_Unlock_Acti1Ref1. It uses the GM_SUS_Unlock_Qust1 to find the nearest locked object.}

; =============================================================
; VARIABLES
; =============================================================

; Properties -----------------------------------------------------

Actor                   Property        _PLAYERREF          Auto
{Set this to the player reference.}

EffectShader            Property        _EFFECT1            Auto
{This effect applies to the locked object when the script unlocks it.}

GlobalVariable          Property        _MAGICKAMAX         Auto
{The global that sets the maximum base cost of the spell.}
GlobalVariable          Property        _MAGICKAMIN         Auto
{The global that sets the minimum base cost of the spell.}
GlobalVariable          Property        _SKILLMAX           Auto
{The global that sets the maximum skill increase of the spell.}
GlobalVariable          Property        _SKILLMIN           Auto
{The global that sets the minimum skill increase of the spell.}

Perk[]                  Property        _PERK_ARRAY         Auto
{Check if the player has the alteration cost reduction perk.}

Quest                   Property        _QUEST1             Auto
{The GM_SUS_Unlock_Qust1 is used to fill the aliases.}

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

Event OnActivate(ObjectReference a_activator)
    
    If (!GetState()) ;make sure it isn’t already running to prevent a ctd from a double spell cast

        GotoState("Moved")

    EndIf

EndEvent

; =============================================================
; FUNCTIONS
; =============================================================

Function CheckLockLvl(int a_value) ;checks the lock level of the object and executes the UnlockTarget function with the appropriate parameters

    If (a_value < 2)            ;Novice
        
        UnlockTarget( _PLAYERREF.HasPerk(_PERK_ARRAY[0]) , Range(0, 1) , Range(0, 0) )
    
    ElseIf (a_value < 26)       ;Apprentice
        
        UnlockTarget( _PLAYERREF.HasPerk(_PERK_ARRAY[1]) , Range(1, 1) , Range(1, 0) )

    ElseIf (a_value < 51)       ;Adept
        
        UnlockTarget( _PLAYERREF.HasPerk(_PERK_ARRAY[2]) , Range(2, 1) , Range(2, 0) )

    ElseIf (a_value < 76)       ;Expert
        
        UnlockTarget( _PLAYERREF.HasPerk(_PERK_ARRAY[3]) , Range(3, 1) , Range(3, 0) )

    ElseIf (a_value < 255)      ;Master
        
        UnlockTarget( _PLAYERREF.HasPerk(_PERK_ARRAY[4]) , Range(4, 1) , Range(4, 0) )

    Else                        ;Key
        
        Debug.Notification("This lock cannot be altered. It requires a key to open.")

    EndIf

EndFunction



float Function Range(int a_int, int a_switch) ;returns the min value, max value, or any divisor values between

    float _max
    float _min

    If (a_switch) ;1 for magicka, 0 for skill

        _max = _MAGICKAMAX.GetValue()
        _min = _MAGICKAMIN.GetValue()

    Else

        _max = _SKILLMAX.GetValue()
        _min = _SKILLMIN.GetValue()

    EndIf
    
    return ( a_int * ( ( _max - _min ) / 4) ) + _min ;an a_int of 0 will return _min, in other words (_max - _min) / the total number of entries - 1

EndFunction



Function UnlockTarget(bool a_bool, float a_mag, float a_skill) ;performs the unlock procedure on the LockedTarget object
    
    float _mod_f =      _PLAYERREF.GetActorValue("AlterationMod")
    float _skill_f =    _PLAYERREF.GetActorValue("Alteration")

    If (_mod_f < 100) ;if the player has an alteration magicka cost reduction modifier that is at 100% or greater, set the magicka cost to 0
        
        a_mag *= ( 1 - ( _mod_f / 100 ) ) * ( 1 - Math.Pow( ( _skill_f / 400 ), 0.65 ) ) ;performs a similar magicka cost calculation to the base game since the spell doesn’t have a cost associated with it

        If (a_bool) ;halves the magicka cost if the player has the corresponding alteration perk
        
            ;Debug.Trace("player has reduction perk!")
            a_mag /= 2

        EndIf

    Else
        
        a_mag = 0

    EndIf

    If (a_mag > _PLAYERREF.GetActorValue("Magicka")) ;ensures the player has enough magicka to unlock the object

        _SOUND2.Play(_PLAYERREF)
        Debug.Notification("You need at least " + a_mag as int + " magicka to alter this lock.")
    
    Else
        
        ;Debug.Trace("magicka cost = " + a_mag)
        ;Debug.Trace("skill increase = " + a_skill)
        _PLAYERREF.DamageActorValue("Magicka", a_mag)
        _locked_or.Lock(false)
        _SOUND1.Play(_locked_or)
        _EFFECT1.Play(_locked_or, 1.0)
        Game.AdvanceSkill("Alteration", a_skill)
        
    EndIf
    
EndFunction

; =============================================================
; STATES
; =============================================================

State Moved
    ;go to this state when activated to start opening a lock

    Event OnBeginState()

        _QUEST1.Start()
        _locked_or = _REFALIAS1.GetReference()

        If (!_locked_or) ;stop the script if the quest doesn’t fill the LockedTarget alias

            GotoState("")
            return

        EndIf

        ;Debug.Trace("LockedTarget = " + _locked_or)
        CheckLockLvl(_locked_or.GetLockLevel())
        GotoState("")

    EndEvent



    Event OnEndState()

        ;Debug.Trace("finished!")
        _QUEST1.Stop()

    EndEvent

EndState