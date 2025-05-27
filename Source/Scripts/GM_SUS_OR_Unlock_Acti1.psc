Scriptname GM_SUS_OR_Unlock_Acti1 extends ObjectReference
{This is used by the GM_SUS_Unlock_Acti1 base. It moves the GM_SUS_Unlock_Acti1Ref1 so the GM_SUS_Unlock_Qust1 to scan near it for locked objects.}

; =============================================================
; VARIABLES
; =============================================================

; Properties -----------------------------------------------------

ObjectReference             Property        _OBJREF1            Auto
{The marker object reference placed in the game world, and used by the Marker alias.}

; =============================================================
; EVENTS
; =============================================================

Event OnInit()

    Self.Delete()
    _OBJREF1.MoveTo(Self)
    _OBJREF1.Activate(Self)

EndEvent