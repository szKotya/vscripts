

myParent <- self.GetMoveParent();
EntFireByHandle(myParent, "SetParent", "Gi_Nattak_Model", 0.02, null, null);

EntFireByHandle(self, "Start", "", 0.00, null, null);

EntFireByHandle(self, "RunScriptCode", "Start()", 10, null, null);
speed <- 20;
check <- false;
function Start()
{
    EntFireByHandle(self, "ClearParent", "", 0, null, null);
    EntFireByHandle(myParent, "RunScriptCode", "self.Destroy();", 0.01, null, null);
    EntFireByHandle(self, "RunScriptCode", "SearchTarget();", 0.01, null, null);
}

function SearchTarget()
{
    local h = null;
    while(null != (h = Entities.FindByClassname(h, "player")))
    {
        if(h != null)
        {
            if(h.IsValid() && h.GetHealth() > 0)
            {
                if(h.GetTeam() == 3)
                {
                    local dir = self.GetOrigin()-(Vector(h.GetOrigin().x, h.GetOrigin().y, 256));
                    dir.Norm();
                    self.SetForwardVector(dir);

                    CreateIgnore();
                    EntFireByHandle(self, "RunScriptCode", "check = true", 0.5, h, h);
                    EntFireByHandle(self, "RunScriptCode", "MoveToTarget()", 0.05, h, h);
                    return;
                }
            }
        }
    }
}

function MoveToTarget()
{
    if(self.IsValid())
    {
        local so = self.GetOrigin();
        if(check)
        {
            if(InSightArray(so, so - (self.GetForwardVector() * speed)))
            {
                EntFireByHandle(self, "FireUser1", "", 0, null, null);
                return;
            }
        }
        self.SetOrigin(so - (self.GetForwardVector() * speed));
        EntFireByHandle(self, "RunScriptCode", "MoveToTarget()", 0.01, null, null);
    }
}

Nattak_script <- Entities.FindByName(null, "Temp_Gi_Nattak");
IgnoreArray <- [];

function CreateIgnore()
{
    local ent
    ent = Entities.FindByName(null, "Gi_Nattak_Phys");
    IgnoreArray.push(ent);
}

function InSight(start,target,handle){if(TraceLine(start,target,handle)<1.00)return false;return true;}
function InSightArray(start,target)
{
    for (local i = 0; i < IgnoreArray.len() ; i++)
    {
        if(InSight(start, target, IgnoreArray[i]))
        {
            //DrawLine(start,target,true);
            return false;
        }
    }
    //DrawLine(start,target,false);
    return true;
}

function DrawLine(start,end,color)
{
    if(color)
        DebugDrawLine(start, end, 0, 255, 0, true, 0.5);
    else
        DebugDrawLine(start, end, 255, 0, 0, true, 5);
}