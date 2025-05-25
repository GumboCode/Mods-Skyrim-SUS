Scriptname GM_SUS_OR_Unlock_Acti1 extends ObjectReference  
{Creates a temporary activator that moves a marker to its location, then the GM_SUS_Unlock_Qust1 uses that marker to find a locked object.}

; =============================================================
; VARIABLES
; =============================================================

; Properties -----------------------------------------------------

ObjectReference         Property        _OBJREF1            Auto

ReferenceAlias          Property        _REFALIAS1          Auto
{The alias that the script measures distance from.}

ReferenceAlias          Property        _REFALIAS2          Auto

Quest                   Property        _QUEST1             Auto
{The quest that uses an alias ref to find a nearby locked object.}

; =============================================================
; EVENTS
; =============================================================

Event OnInit()

    GotoState("Created")

EndEvent

; =============================================================
; STATES
; =============================================================

State Created

; Events -----------------------------------------------------

    Event OnBeginState()

        _OBJREF1.MoveTo(Self)
        _QUEST1.Start()
        Debug.Trace("Marker = " + _REFALIAS1.GetReference())
        Debug.Trace("LockedTarget = " + _REFALIAS2.GetReference())

        Utility.Wait(5)

        GotoState("")

    EndEvent



    Event OnEndState()

        _QUEST1.Stop()

        Self.Delete()

    EndEvent

EndState