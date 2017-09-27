class RenameEventsToWeekends < ActiveRecord::Migration[5.0]
    def up

        # Rename Tables
        rename_table :events, :weekends
        rename_table :event_attendees, :weekend_attendees
        rename_table :meetings, :weekend_meetings
        rename_table :meeting_attendees, :weekend_meeting_attendees
        rename_table :payments, :weekend_payments
        rename_table :nominations, :weekend_nominations
        rename_table :team_apps, :weekend_team_apps
        rename_table :general_funds, :weekend_general_funds

        # Person
        remove_index :people, :event_id
        rename_column :people, :event_id, :weekend_id
        rename_column :people, :birth_event_alt, :birth_weekend_alt
        add_index :people, :weekend_id

        # Attendees
        remove_index :weekend_attendees, :event_id
        rename_column :weekend_attendees, :event_id, :weekend_id
        add_index :weekend_attendees, :weekend_id

        # Nominations
        remove_index :weekend_nominations, :m_event_id
        remove_index :weekend_nominations, :f_event_id
        rename_column :weekend_nominations, :m_event_id, :m_weekend_id
        rename_column :weekend_nominations, :f_event_id, :f_weekend_id
        add_index :weekend_nominations, :m_weekend_id
        add_index :weekend_nominations, :f_weekend_id

        # General Fund
        remove_index :weekend_general_funds, :event_id
        rename_column :weekend_general_funds, :event_id, :weekend_id
        add_index :weekend_general_funds, :weekend_id

        # Meeting
        remove_index :weekend_meetings, :event_id
        rename_column :weekend_meetings, :event_id, :weekend_id
        add_index :weekend_meetings, :weekend_id

        # Payment
        rename_column :weekend_payments, :event_id, :weekend_id
        add_index :weekend_payments, :weekend_id

        # Team App
        remove_index :weekend_team_apps, :event_id
        rename_column :weekend_team_apps, :event_id, :weekend_id
        add_index :weekend_team_apps, :weekend_id
    end

    def down

        # Name Tables back
        rename_table :weekends, :events
        rename_table :weekend_attendees, :event_attendees
        rename_table :weekend_meetings, :meetings
        rename_table :weekend_meeting_attendees, :meeting_attendees
        rename_table :weekend_payments, :payments
        rename_table :weekend_nominations, :nominations
        rename_table :weekend_team_apps, :team_apps
        rename_table :weekend_general_funds, :general_funds

        # Person
        remove_index :people, :weekend_id
        rename_column :people, :weekend_id, :event_id
        rename_column :people, :birth_weekend_alt, :birth_event_alt
        add_index :people, :event_id

        # Attendees
        remove_index :event_attendees, :weekend_id
        rename_column :event_attendees, :weekend_id, :event_id
        add_index :event_attendees, :event_id

        # Nominations
        remove_index :nominations, :m_weekend_id
        remove_index :nominations, :f_weekend_id
        rename_column :nominations, :m_weekend_id, :m_event_id
        rename_column :nominations, :f_weekend_id, :f_event_id
        add_index :nominations, :m_event_id
        add_index :nominations, :f_event_id

        # General Fund
        remove_index :general_funds, :weekend_id
        rename_column :general_funds, :weekend_id, :event_id
        add_index :general_funds, :event_id

        # Meeting
        remove_index :meetings, :weekend_id
        rename_column :meetings, :weekend_id, :event_id
        add_index :meetings, :event_id

        # Payment
        remove_index :payments, :weekend_id
        rename_column :payments, :weekend_id, :event_id
        # add_index :payments, :event_id

        # Team App
        remove_index :team_apps, :weekend_id
        rename_column :team_apps, :weekend_id, :event_id
        add_index :team_apps, :event_id

    end

end
