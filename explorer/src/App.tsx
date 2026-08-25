import React, { useState } from 'react';

export default function App() {
  const [query, setQuery] = useState('');

  return (
    <div style={{ fontFamily: 'system-ui, sans-serif', padding: '2rem', maxWidth: '1200px', margin: '0 auto' }}>
      <header style={{ marginBottom: '2rem' }}>
        <h1 style={{ fontSize: '2rem', fontWeight: 'bold' }}>🔬 Postmortem Machine</h1>
        <p style={{ color: '#64748b' }}>
          Explore failure patterns and audit your systems against real-world incidents.
        </p>
      </header>

      <section style={{ marginBottom: '2rem' }}>
        <input
          type="text"
          placeholder="Search failure patterns (e.g., DNS split-brain, cascade timeout)..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          style={{
            width: '100%',
            padding: '0.75rem 1rem',
            borderRadius: '0.5rem',
            border: '1px solid #cbd5e1',
            fontSize: '1rem',
          }}
        />
      </section>

      <main>
        <div style={{ border: '1px dashed #cbd5e1', borderRadius: '0.5rem', padding: '2rem', textAlign: 'center' }}>
          <p style={{ color: '#94a3b8' }}>Incident Explorer dashboard active. No incidents loaded yet.</p>
        </div>
      </main>
    </div>
  );
}
