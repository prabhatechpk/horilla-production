from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.timezone import now

User = get_user_model()

class UserAdmin(BaseUserAdmin):
    # Columns on Users changelist
    list_display = ("username", "email", "is_active", "is_staff", "is_superuser", "account_age")
    list_filter = ("is_active", "is_staff", "is_superuser", "groups")
    search_fields = ("username", "email", "first_name", "last_name")

    # Fields on the EDIT page
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        ("Personal info", {"fields": ("first_name", "last_name", "email")}),
        ("Permissions", {"fields": ("is_active", "is_staff", "is_superuser")}),
        ("Important dates", {"fields": ("last_login", "date_joined")}),
    )

    # Fields on the ADD page
    add_fieldsets = (
        (None, {
            "classes": ("wide",),
            "fields": (
                "username", "password1", "password2",
                "is_active", "is_staff", "is_superuser"
            ),
        }),
    )

    # Read-only computed column
    def account_age(self, obj):
        return f"{(now() - obj.date_joined).days}d"
    account_age.short_description = "Age"

    # Bulk action to promote
    actions = ["make_superuser"]

    def make_superuser(self, request, queryset):
        updated = queryset.update(is_superuser=True, is_staff=True)
        self.message_user(request, f"{updated} user(s) promoted to superuser.")
    make_superuser.short_description = "Mark selected users as superusers"

# Swap in our customized admin
try:
    admin.site.unregister(User)
except admin.sites.NotRegistered:
    pass
admin.site.register(User, UserAdmin)
