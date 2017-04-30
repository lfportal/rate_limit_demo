# frozen_string_literal: true

# Configuration for Throttler middleware
Rack::Throttler.throttle(pattern: %r{^/$}, method: 'get', limit: 100, period: 1.hour)
