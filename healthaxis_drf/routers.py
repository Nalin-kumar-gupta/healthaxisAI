class HealthAxisDatabaseRouter:
    """
    A router to control database operations for specific models.
    """

    def db_for_read(self, model, **hints):
        """
        Direct read operations to the appropriate database.
        """
        if model._meta.app_label == 'mongo_app':
            return 'mongo'  # Use the 'mongo' database for this app
        return 'default'  # Use the default database for everything else

    def db_for_write(self, model, **hints):
        """
        Direct write operations to the appropriate database.
        """
        if model._meta.app_label == 'mongo_app':
            return 'mongo'  # Use the 'mongo' database for this app
        return 'default'  # Use the default database for everything else

    def allow_relation(self, obj1, obj2, **hints):
        """
        Allow relations if both objects are in the same database.
        """
        db_set = {'default', 'mongo'}
        if obj1._state.db in db_set and obj2._state.db in db_set:
            return True
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        """
        Ensure that apps only appear in their designated databases.
        """
        if app_label == 'mongo_app':
            return db == 'mongo'
        return db == 'default'
