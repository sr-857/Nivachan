-- Admin Tables
CREATE TABLE admin_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role TEXT CHECK (role IN ('super_admin', 'moderator')),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE TABLE admin_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  admin_id UUID REFERENCES users(id),
  action TEXT NOT NULL,
  target_type TEXT,
  target_id UUID,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Admin security policies
ALTER TABLE admin_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view roles" ON admin_roles FOR SELECT USING (EXISTS (SELECT 1 FROM admin_roles WHERE user_id = auth.uid()));
CREATE POLICY "Admins can view logs" ON admin_logs FOR SELECT USING (EXISTS (SELECT 1 FROM admin_roles WHERE user_id = auth.uid()));
CREATE POLICY "System can log actions" ON admin_logs FOR INSERT WITH CHECK (true);
