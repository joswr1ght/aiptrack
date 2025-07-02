import React, { useState, useEffect } from 'react';
import axios from 'axios';

const Dashboard = () => {
  const [healthStatus, setHealthStatus] = useState('Loading...');

  useEffect(() => {
    const checkHealth = async () => {
      try {
        const response = await axios.get(`${process.env.REACT_APP_API_URL || 'http://localhost:3001'}/health`);
        setHealthStatus('Backend Connected ✅');
      } catch (error) {
        setHealthStatus('Backend Disconnected ❌');
      }
    };

    checkHealth();
  }, []);

  return (
    <div className="dashboard">
      <h2>Dashboard</h2>
      <p>Welcome to AIP Track - AI Project Tracking System</p>
      <div>
        <h3>System Status</h3>
        <p>Backend: {healthStatus}</p>
      </div>
      <div>
        <h3>Quick Actions</h3>
        <ul>
          <li>View Projects</li>
          <li>Create New Project</li>
          <li>View Analytics</li>
          <li>Manage Users</li>
        </ul>
      </div>
    </div>
  );
};

export default Dashboard;
