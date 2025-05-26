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

ReferenceAlias          Property        _REFALIAS1          Auto
{The LockedTarget alias that the quest uses to select the nearest locked object.}

Quest                   Property        _QUEST1             Auto
{The GM_SUS_Unlock_Qust1 quest is used to fill the aliases.}

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

        _locked_or.Lock(false)
        _EFFECT1.Play(_locked_or, 2.0)

        GotoState("")

    EndEvent



    Event OnEndState()

        CleanUp()

    EndEvent

EndState