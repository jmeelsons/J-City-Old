local function TrackHandGrab()
    for i, ply in player.Iterator() do
        local ragdoll = ply.FakeRagdoll
        if IsValid(ragdoll) then
            local lh = IsValid(ragdoll.ConsLH)
            local rh = IsValid(ragdoll.ConsRH)

            if ply.lhGrab ~= lh then
                ply.lhGrab = lh
                ply:SetNWBool("HG_LHandGrab", lh)
            end

            if ply.rhGrab ~= rh then
                ply.rhGrab = rh
                ply:SetNWBool("HG_RHandGrab", rh)
            end
        else
            if ply.lhGrab then
                ply.lhGrab = false
                ply:SetNWBool("HG_LHandGrab", false)
            end
            if ply.rhGrab then
                ply.rhGrab = false
                ply:SetNWBool("HG_RHandGrab", false)
            end
        end
    end
end

hook.Add("Think", "HG_HandGrabTracker", TrackHandGrab)

hook.Add("PlayerDisconnected", "HG_Cleanup", function(ply)
    ply.lhGrab = nil
    ply.rhGrab = nil
end)