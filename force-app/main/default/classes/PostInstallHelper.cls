global class PostInstallHelper implements InstallHandler {

    global void onInstall(InstallContext context) {
      if(context.previousVersion() == null) {
            PostInstallHelper.AssignAdministratorAllPermissions(context.installerID());
        }
    } 

    public static User AssignAdministratorAllPermissions(Id userId){
        User user = [Select Id, Email from User where Id =:userId];
        if(user!=null){
            AssignAdministratorAllPermissions(user);
        }   
        return user;
    }

    private static void AssignAdministratorAllPermissions(User user){
        
        List<PermissionSet> permissionSets = [
            SELECT 
            Id, 
            Name, 
            Label, 
            Type, 
            NamespacePrefix 
            FROM PermissionSet
            WHERE Type = 'Regular' AND NamespacePrefix = 'dmpl'];

        List<PermissionSetAssignment> psAssignments = [SELECT 
            Id, 
            PermissionSetId, 
            AssigneeId 
            FROM PermissionSetAssignment 
            WHERE AssigneeId =:user.Id];

        for(PermissionSet ps : permissionSets){
            if(CollectionHelper.getObject(psAssignments, 'PermissionSetId', ps.Id)!=null){
                continue;
            }
            psAssignments.add(new PermissionSetAssignment(
                AssigneeId = user.Id,
                PermissionSetId = ps.Id
            ));
        }

        if(psAssignments.size()>0){
            upsert psAssignments;
        }
    }
}