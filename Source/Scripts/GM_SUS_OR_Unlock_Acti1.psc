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

    _QUEST1.Stop()
    GotoState("Created")

EndEvent

; =============================================================
; FUNCTIONS
; =============================================================

Function CalcCost(float a_mag = 0.0)
    
    float _mod_f = _PLAYERREF.GetActorValue("AlterationMod")

    If (_mod_f < 100)
        
        a_mag -= (_mod_f * 0.01) * a_mag
        _PLAYERREF.DamageActorValue("Magicka", a_mag)

    EndIf

    _locked_or.Lock(false)
    _EFFECT1.Play(_locked_or, 1.0)
    
EndFunction

int Function CheckLockLvl(int a_value)
    
    If (a_value < 2)            ;Novice
        
        return 1
    
    ElseIf (a_value < 26)       ;Apprentice
        
        return 1

    ElseIf (a_value < 51)       ;Adept
        
        return 1

    ElseIf (a_value < 76)       ;Expert
        
        return 1

    ElseIf (a_value < 255)      ;Master
        
        return 1

    Else                        ;Key
        
        return 0

    EndIf

EndFunction

Function CleanUp()

    _QUEST1.Stop()
    Self.Delete()
    Debug.Trace("finished!")

EndFunction

; =============================================================
; STATES
; =============================================================

State Created

    Event OnBeginState()

        _OBJREF1.MoveTo(Self)
        _QUEST1.Start()
        _locked_or = _REFALIAS1.GetReference()

        If (!_locked_or)

            CleanUp()
            return

        EndIf

        Debug.Trace("LockedTarget = " + _locked_or)
        int _lock_i = CheckLockLvl(_locked_or.GetLockLevel())

        If (!_lock_i)
            
            Debug.Notification("This lock cannot be altered. It requires a key to open.")
            CleanUp()
            return

        EndIf

        GotoState("")

    EndEvent



    Event OnEndState()

        CleanUp()

    EndEvent

EndState