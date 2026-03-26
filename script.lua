local a=game:GetService"HttpService"
local b=game:GetService"Players"
local c=game:GetService"TweenService"


local d="https://raw.githubusercontent.com/Laucs-sudo/banlist/refs/heads/main/banlist.json"
local e={
97385070282211,
96934141342962,
139945781730068,
96820257284291,
74687684906269,
3351770504
}

local f={}
local g=""

local function hash(h)
return tostring(#h)..h:sub(1,50)
end


local function kickIfBanned(h)
local i=f[h.UserId]
if i then
print(h.DisplayName.." tried to join but banned due to "..i)local
j=pcall(function()
h:Kick("Banned: "..i.."\n\nDM \".Laucs\" if you wanna get unbanned")
end)
if not j then
warn("Kick failed for player "..h.Name)
end
end
end


local function fetchBanList()
local h,i=pcall(function()
return a:GetAsync(d)
end)
if h then
local j=hash(i)
if j~=g then
g=j
local k=a:JSONDecode(i)
local l={}
for m,n in ipairs(k)do
local o=tonumber(n.id)
if o then
l[o]=n.reason or"No reason provided"
end
end
f=l
print"Ban list updated"
for m,n in ipairs(b:GetPlayers())do
kickIfBanned(n)
end
end
else
warn("Failed to fetch ban list:",i)
end
end


local function setupAntiSkid(h)
local i=h:WaitForChild"PlayerGui"
local j=i:FindFirstChild"AntiSkidGUI"
if j then j:Destroy()end

local k=Instance.new"ScreenGui"
k.Name="AntiSkidGUI"
k.ResetOnSpawn=false
k.Parent=i

local l=Instance.new"Frame"
l.Size=UDim2.new(0,400,0,100)
l.Position=UDim2.new(0.5,-200,-0.2,0)
l.BackgroundColor3=Color3.fromRGB(20,20,20)
l.BorderSizePixel=0
l.BackgroundTransparency=0.2
l.Parent=k

local m=Instance.new"TextLabel"
m.Size=UDim2.new(1,0,1,0)
m.Position=UDim2.new(0,0,0,0)
m.BackgroundTransparency=1
m.TextColor3=Color3.fromRGB(255,255,255)
m.Font=Enum.Font.GothamBold
m.TextScaled=true
m.Text="Laucs Anti Skid Is Running"
m.Parent=l


local n=e[math.random(1,#e)]
local o=Instance.new"Sound"
o.SoundId="rbxassetid://"..n
o.Volume=1
o.Looped=false
o.Parent=l
o:Play()


local p=c:Create(l,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-200,0.05,0)})
p:Play()


o.Ended:Connect(function()
task.wait(5)
local q=c:Create(l,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-200,-0.2,0)})
q:Play()
q.Completed:Connect(function()
k:Destroy()
end)
end)
end


local function setupPlayer(h)
setupAntiSkid(h)
kickIfBanned(h)
h.CharacterAdded:Connect(function()
setupAntiSkid(h)
end)
end

b.PlayerAdded:Connect(setupPlayer)
for h,i in ipairs(b:GetPlayers())do
setupPlayer(i)
end

fetchBanList()


task.spawn(function()
while true do
task.wait(10)
fetchBanList()
end
end)
