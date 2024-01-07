CREATE TABLE users (
    id UUID PRIMARY KEY,
    allow_notifications boolean,
    days_of_streak integer,
    overall_progress numeric,
    remaining_tasks integer,
    updated_at timestamp without time zone
);

CREATE INDEX idx_users_id ON users (id);
